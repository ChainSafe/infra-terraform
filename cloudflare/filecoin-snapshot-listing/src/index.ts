import {type Env, getBucketListingObj, getBucketObjects} from './buckets';
import {do_listing_v2} from './listings';
import {fetch_file} from './files';
import {renderSnapshotsHomePage} from './templates';

// noinspection JSUnusedGlobalSymbols
export default {
  async fetch(request: Request, env: Env) {
    switch (request.method) {
      case 'HEAD':
      case 'GET': {
        const url = new URL(request.url);
        const {pathname} = url;
        if (pathname.startsWith('/archive/')) {
          const [, , bucketType, ...filePathParts] = pathname.split('/');
          const filePath = filePathParts.join('/');
          const bucket = getBucketListingObj(bucketType, env);
          return fetch_file(bucket, filePath, request); // Pass the request object here
        }

        if (pathname.startsWith('/latest/')) {
          const [, chain] = pathname.split('/');
          const bucket = env.SNAPSHOT_ARCHIVE
          const objects = await getBucketObjects(bucket, `${chain}/latest/`, true);

          return fetch_file(bucket, objects[0].key, request);
        }

        if (pathname.startsWith('/latest-v2/')) {
          const [, chain] = pathname.split('/');
          const bucket = env.SNAPSHOT_ARCHIVE_V2
          const objects = await getBucketObjects(bucket, `${chain}/latest-v2/`, true);

          return fetch_file(bucket, objects[0].key, request);
        }

        switch (pathname) {
          case '/list':
          case '/list/': {
              return new Response(renderSnapshotsHomePage(), { headers: { 'content-type': 'text/html' } });
          }
          case '/list/favicon.ico':
            return env.ASSETS.fetch(request);
          case '/list/calibnet/latest-v2':
            return do_listing_v2(env, env.SNAPSHOT_ARCHIVE_V2, 'calibnet/latest-v2', 'Calibnet Snapshots v2 (last 14 days)');
          case '/list/mainnet/latest':
            return do_listing_v2(env, env.SNAPSHOT_ARCHIVE, 'mainnet/latest', 'Mainnet Latest Snapshots (last 14 days)');
          case '/list/calibnet/latest':
            return do_listing_v2(env, env.SNAPSHOT_ARCHIVE, 'calibnet/latest', 'Calibnet Latest Snapshots (last 14 days)');
          case '/list/mainnet/diff':
            return do_listing_v2(env, env.FOREST_ARCHIVE, 'mainnet/diff', 'Mainnet Diff Snapshots Archive');
          case '/list/calibnet/diff':
            return do_listing_v2(env, env.FOREST_ARCHIVE, 'calibnet/diff', 'Calibnet Diff Snapshots Archive');
          case '/list/mainnet/lite':
            return do_listing_v2(env, env.FOREST_ARCHIVE, 'mainnet/lite', 'Mainnet Lite Snapshots Archive');
          case '/list/calibnet/lite':
            return do_listing_v2(env, env.FOREST_ARCHIVE, 'calibnet/lite', 'Calibnet Lite Snapshots Archive');
          default:
            return env.ASSETS.fetch(request);
        }
      }
      default: {
        return new Response('Method not allowed', {
          status: 405,
          headers: {
            Allow: 'GET, HEAD',
          },
        });
      }
    }
  },
};
