import http from "k6/http";
import {check, fail} from "k6";
import {parseHTML} from "k6/html";
import {Gauge, Trend} from "k6/metrics";

// Define k6 options
export const options = {
  scenarios: {
    default: {
      executor: "per-vu-iterations", vus: 1, iterations: 1, maxDuration: "2m",
    },
  }, thresholds: {
    checks: ["rate==1"], // The rate of successful checks should be 100%
  }
};

// Custom metrics
const snapshotAgeGauge = new Gauge("snapshot_age_minutes");
const orphanSnapshotGauge = new Gauge("orphan_snapshot_age_minutes");
const orphanShasumGauge = new Gauge("orphan_shasum_age_minutes");
const latestSnapshotEpochGauge = new Gauge("latest_snapshot_epoch");
const totalSnapshotsGauge = new Gauge("total_snapshots");
const totalShasumsGauge = new Gauge("total_shasums");
const snapshotLatencyTrend = new Trend("snapshot_latency", true);
const totalOrphanFilesGauge = new Gauge("total_orphan_files");

// Base URLs
const BASE_URL = "https://forest-archive.chainsafe.dev";
const CALIBNET_SNAPSHOT_URL = `${BASE_URL}/latest/calibnet`;
const MAINNET_SNAPSHOT_URL = `${BASE_URL}/latest/mainnet`;
const CALIBNET_LIST_URL = `${BASE_URL}/list/calibnet/latest`;
const MAINNET_LIST_URL = `${BASE_URL}/list/mainnet/latest`;
const CALIBNET_GENESIS_TIME = 1667326380;
const MAINNET_GENESIS_TIME = 1598306400;

// noinspection JSUnusedGlobalSymbols
export default function () {
  let allChecksPassed = true;

  // Check age of snapshots
  allChecksPassed = checkSnapshotAge(CALIBNET_SNAPSHOT_URL, CALIBNET_GENESIS_TIME, "calibnet",) && allChecksPassed;
  allChecksPassed = checkSnapshotAge(MAINNET_SNAPSHOT_URL, MAINNET_GENESIS_TIME, "mainnet") && allChecksPassed;

  // Check for orphan snapshot files
  // allChecksPassed = checkOrphanFiles(CALIBNET_LIST_URL, CALIBNET_GENESIS_TIME, "calibnet") && allChecksPassed;
  // allChecksPassed = checkOrphanFiles(MAINNET_LIST_URL, MAINNET_GENESIS_TIME, "mainnet") && allChecksPassed;

  // Fail the script if any check failed
  if (!allChecksPassed) {
    fail("One or more checks failed.");
  }
}

function checkSnapshotAge(url, genesisTime, network) {
  const startTime = Date.now();
  const response = http.head(url);
  const latency = Date.now() - startTime;
  snapshotLatencyTrend.add(latency, {network});

  const statusCheck = check(response, {
    "status is 200": (r) => r.status === 200,
  });

  if (!statusCheck) {
    console.error(`Expected a 200 OK response for ${network}, but got ${response.status}`,);
    return false;
  }

  const snapshotName = response.headers.Url.split("/").pop();
  const heightMatch = snapshotName.match(/height_(\d+)/);
  if (!heightMatch) {
    console.error(`Height not found in ${network} snapshot name`);
    return false;
  }

  const height = parseInt(heightMatch[1], 10);
  const snapshotAgeInMinutes = calculateFileAgeInMinutes(height, genesisTime);

  console.log(`${network} Snapshot Age in Minutes: ${snapshotAgeInMinutes}`);
  snapshotAgeGauge.add(snapshotAgeInMinutes, {network: network});
  latestSnapshotEpochGauge.add(height, {network: network}); // Add height directly as the epoch

  const ageCheck = check(null, {
    [`The latest ${network} snapshot is less than 180 minutes old, it is ${snapshotAgeInMinutes}`]: () => snapshotAgeInMinutes < 180,
  });

  if (!ageCheck) {
    console.error(`Expected ${network} snapshot to be less than 180 minutes old, but got ${snapshotAgeInMinutes} minutes`,);
    return false;
  }

  return true;
}

function checkOrphanFiles(url, genesisTime, network) {
  const response = http.get(url);

  const statusCheck = check(response, {
    "status is 200": (r) => r.status === 200,
  });

  if (!statusCheck) {
    console.error(`Failed to load snapshot page: ${url}`);
    return false;
  }

  // Parse the HTML response
  const doc = parseHTML(response.body);
  const links = doc.find("a");
  let snapshotFiles = [];
  let shasumFiles = [];
  let orphanFileCount = 0;

  // Find and categorize files
  links.each((index, link) => {
    const href = link.getAttribute("href");
    if (href) {
      if (href.includes("height_") && href.endsWith(".car.zst")) {
        snapshotFiles.push(href);
      } else if (href.includes(".car.sha256sum")) {
        shasumFiles.push(href);
      }
    }
  });

  totalSnapshotsGauge.add(snapshotFiles.length, {network: network});
  totalShasumsGauge.add(shasumFiles.length, {network: network});

  // Check for missing SHA256SUM files and vice versa
  let allSnapshotsHaveShasum = true;
  let allShasumsHaveSnapshot = true;

  snapshotFiles.forEach((snapshot) => {
    const shasum = snapshot.replace(".car.zst", ".car.sha256sum");
    if (!shasumFiles.includes(shasum)) {
      const heightMatch = snapshot.match(/height_(\d+)/);
      if (heightMatch) {
        const height = parseInt(heightMatch[1], 10);
        const orphanAgeInMinutes = calculateFileAgeInMinutes(height, genesisTime,);
        if (orphanAgeInMinutes > 240) {
          console.error(`${network} orphan snapshot ${snapshot} is older than 240 minutes`,);
          orphanSnapshotGauge.add(orphanAgeInMinutes, {network: network});
          allSnapshotsHaveShasum = false;
          orphanFileCount++;
        } else {
          console.log(`${network} orphan snapshot ${snapshot} is younger than 240 minutes`,);
        }
      }
    }
  });

  shasumFiles.forEach((shasum) => {
    const snapshot = shasum.replace(".car.sha256sum", ".car.zst");
    if (!snapshotFiles.includes(snapshot)) {
      const heightMatch = shasum.match(/height_(\d+)/);
      if (heightMatch) {
        const height = parseInt(heightMatch[1], 10);
        const orphanAgeInMinutes = calculateFileAgeInMinutes(height, genesisTime,);
        if (orphanAgeInMinutes > 240) {
          console.error(`${network} orphan SHA256SUM ${shasum} is older than 240 minutes`,);
          orphanShasumGauge.add(orphanAgeInMinutes, {network: network});
          allShasumsHaveSnapshot = false;
          orphanFileCount++;
        } else {
          console.log(`${network} orphan SHA256SUM ${shasum} is younger than 240 minutes`,);
        }
      }
    }
  });

  if (allSnapshotsHaveShasum) {
    orphanSnapshotGauge.add(0, {network: network});
  }
  if (allShasumsHaveSnapshot) {
    orphanShasumGauge.add(0, {network: network});
  }

  totalOrphanFilesGauge.add(orphanFileCount, {network: network});

  const shaCheck = check(null, {
    [`${network} snapshots have corresponding SHA256SUM files`]: () => allSnapshotsHaveShasum,
    [`${network} SHA256SUM files have corresponding snapshots`]: () => allShasumsHaveSnapshot,
  });

  if (!shaCheck) {
    console.error(`${network} SHA256SUM check failed`);
    return false;
  }

  return true;
}

function calculateFileAgeInMinutes(height, genesisTime) {
  const currentTime = Math.floor(Date.now() / 1000);
  const fileTime = height * 30 + genesisTime;
  return (currentTime - fileTime) / 60;
}
