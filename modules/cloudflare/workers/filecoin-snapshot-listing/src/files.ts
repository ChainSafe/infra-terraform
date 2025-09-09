import parseRange from 'range-parser';

export async function fetch_file(bucket: R2Bucket, path: string, request: Request): Promise<Response> {
	const object = await bucket.get(path);

	if (!object) {
		return new Response(`File not found: ${path}.`, { status: 404 });
	}

	const headers = new Headers();
	headers.set('Content-Type', object.httpMetadata?.contentType || 'application/octet-stream');
	headers.set('Content-Disposition', `attachment; filename="${encodeURIComponent(path.split('/').pop()!)}"`);

	let status = 200;

	const rangeHeader = request.headers.get('range');
	if (rangeHeader) {
		const range = parseRange(object.size, rangeHeader);
		if (Array.isArray(range)) {
			if (range.length > 1) {
				return new Response('Multiple ranges are not supported', {
					status: 416, // Range Not Satisfiable
				});
			}

			const r = range[0];
			headers.set('Content-Range', `bytes ${r.start}-${r.end}/${object.size}`);
			headers.set('Content-Length', `${r.end - r.start + 1}`);
			status = 206; // Partial Content

			// Serve only the requested byte range
			const objectPart = await bucket.get(path, {
				range: { offset: r.start, length: r.end - r.start + 1 },
			});
			if (objectPart?.body) {
				return new Response(objectPart.body as unknown as BodyInit, { headers, status });
			}
		} else {
			headers.set('Content-Length', object.size.toString());
		}
	} else {
		headers.set('Content-Length', object.size.toString());
	}

	const responseBody = 'body' in object ? object.body : null;
	return new Response(responseBody as unknown as BodyInit, { headers, status });
}
