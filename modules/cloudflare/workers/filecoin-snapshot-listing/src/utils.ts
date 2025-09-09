export function formatFileSize(size: number) {
	if (size < 1024) {
		return `${size} B`;
	} else if (size < 1000 * 1024) {
		return `${(size / 1024).toFixed(2)} KB`;
	} else if (size < 1000 * 1000 * 1024) {
		return `${(size / (1024 * 1024)).toFixed(2)} MB`;
	} else {
		return `${(size / (1024 * 1024 * 1024)).toFixed(2)} GB`;
	}
}

export function arrayBufferToString(buffer: ArrayBuffer, encoding: 'utf-8' | 'hex' = 'utf-8'): string {
	if (encoding === 'hex') {
		const bytes = new Uint8Array(buffer);
		let out = '';
		for (let i = 0; i < bytes.length; i++) {
			out += bytes[i].toString(16).padStart(2, '0');
		}
		return out;
	}
	const decoder = new TextDecoder('utf-8');
	return decoder.decode(buffer);
}

export function arrayBufferToHex(buf: ArrayBuffer): string {
	const bytes = new Uint8Array(buf);
	let hex = '';
	for (let i = 0; i < bytes.length; i++) hex += bytes[i].toString(16).padStart(2, '0');
	return hex;
}
