import {arrayBufferToHex} from './utils';

export interface Env {
  FOREST_ARCHIVE: R2Bucket;
  SNAPSHOT_ARCHIVE: R2Bucket;
  SNAPSHOT_ARCHIVE_V2: R2Bucket;
  ASSETS: Fetcher;
}

interface R2ObjectWithTimestamp {
  key: string;
  size: number;
  sha256sum: string;
  uploaded: Date;
}

/**
 * Map a known R2 bucket instance to its short listing name.
 *
 * Returns 'forest', 'snapshot', or 'snapshot-v2' for the corresponding Env bucket; if the provided bucket is not one of the known env buckets the function defaults to 'forest'.
 *
 * @returns The short listing name for the given bucket.
 */
export function getBucketListingName(bucket: R2Bucket, env: Env): string {
  const bucketMap = new Map<R2Bucket, string>([
    [env.FOREST_ARCHIVE, 'forest'],
    [env.SNAPSHOT_ARCHIVE, 'snapshot'],
    [env.SNAPSHOT_ARCHIVE_V2, 'snapshot-v2'],
  ]);

  return bucketMap.get(bucket) || 'forest';
}

export function getBucketListingObj(name: string, env: Env): R2Bucket {
  const bucketMap = new Map<string, R2Bucket>([
    ['forest', env.FOREST_ARCHIVE],
    ['snapshot', env.SNAPSHOT_ARCHIVE],
    ['snapshot-v2', env.SNAPSHOT_ARCHIVE_V2],
  ]);

  return bucketMap.get(name) || env.FOREST_ARCHIVE;
}

export async function getBucketObjects(bucket: R2Bucket, prefix: string, latest: boolean = false): Promise<R2ObjectWithTimestamp[]> {
  const objects: R2ObjectWithTimestamp[] = [];

  let cursor: string | undefined = undefined;
  let truncated = true;

  while (truncated) {
    const result = await bucket.list({limit: 500, prefix: prefix, cursor});
    for (const obj of result.objects) {
      let sha256 = '';
      if (obj.checksums.sha256) {
        sha256 = arrayBufferToHex(obj.checksums.sha256);
      }
      objects.push({
        key: obj.key,
        size: obj.size,
        sha256sum: sha256,
        uploaded: obj.uploaded ?? new Date(),
      });
    }

    truncated = result.truncated;
    cursor = result.truncated ? result.cursor : undefined;
  }
  const keys = new Set(objects.map(o => o.key)); // quick lookup

  if (latest) {
    return [
      objects.filter(
        obj => obj.key.endsWith('.car.zst') && keys.has(`${obj.key}.sha256sum`)
      ).sort(
        (a, b) =>
          +b.key.match(/height_(\d+)/)![1] - +a.key.match(/height_(\d+)/)![1]
      )[0] ?? null
    ]
  } else {
    return objects.sort(
      (a, b) =>
        +b.key.match(/height_(\d+)/)![1] - +a.key.match(/height_(\d+)/)![1]
    )
  }
}
