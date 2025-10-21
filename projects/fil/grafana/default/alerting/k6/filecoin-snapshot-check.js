// noinspection NpmUsedModulesInstalled

import http from "k6/http";
import {check, fail, group} from "k6";
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
const latestSnapshotEpochGauge = new Gauge("latest_snapshot_epoch");
const snapshotLatencyTrend = new Trend("snapshot_latency", true);

// Base URLs
const BASE_URL = "https://forest-archive.chainsafe.dev";
const CALIBNET_SNAPSHOT_URL = `${BASE_URL}/latest/calibnet`;
const MAINNET_SNAPSHOT_URL = `${BASE_URL}/latest/mainnet`;
const CALIBNET_GENESIS_TIME = 1667326380;
const MAINNET_GENESIS_TIME = 1598306400;

export default function () {
  const failedChecks = [];

  // Group for Calibnet
  group('Calibnet Snapshot Checks', () => {
    if (!checkSnapshotAge(CALIBNET_SNAPSHOT_URL, CALIBNET_GENESIS_TIME, 'calibnet')) {
      failedChecks.push('Calibnet snapshot check failed');
    }
  });

  // Group for Mainnet
  group('Mainnet Snapshot Checks', () => {
    if (!checkSnapshotAge(MAINNET_SNAPSHOT_URL, MAINNET_GENESIS_TIME, 'mainnet')) {
      failedChecks.push('Mainnet snapshot check failed');
    }
  });

  // Fail the script if any check failed
  if (failedChecks.length > 0) {
    fail(`One or more snapshot checks failed:\n- ${failedChecks.join('\n- ')}`);
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

function calculateFileAgeInMinutes(height, genesisTime) {
  const currentTime = Math.floor(new Date().getTime() / 1000);
  const fileTime = height * 30 + genesisTime;
  return Math.round((currentTime - fileTime) / 60);
}
