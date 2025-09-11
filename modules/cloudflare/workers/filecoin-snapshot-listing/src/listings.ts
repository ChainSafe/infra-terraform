import type { Env } from './buckets';
import { getBucketListingName, getBucketObjects } from './buckets';
import { renderListingPageTemplate, renderSnapshotCardTemplate } from './templates';
import { formatFileSize } from './utils';

export async function do_listing_v2(env: Env, bucket: R2Bucket, prefix: string, title: string = 'Filecoin Snapshots 14 days Archive') {
	const listedObjects = await getBucketObjects(bucket, prefix);

	// build HTML with Tailwind
	let bodyContent = `
  <div id="snapshotGrid" class="flex flex-col gap-4">
`;

	for (const obj of listedObjects) {
		if (!obj.key.endsWith('.car.zst')) continue;

		const base = `/archive/${getBucketListingName(bucket, env)}/${obj.key}`;
		const fileSize = formatFileSize(obj.size);
    const snap_type = bucket === env.SNAPSHOT_ARCHIVE_V2 ? "v2" : "v1";

		bodyContent += renderSnapshotCardTemplate(obj.key, base, fileSize, obj.uploaded, snap_type);
	}

	bodyContent += `</div>`;

	const html = renderListingPageTemplate(title, bodyContent);

	return new Response(html, {
		headers: {
			'content-type': 'text/html;charset=UTF-8',
		},
	});
}
