export function renderListingPageTemplate(title: string, bodyContent: string): string {
	return `<!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="UTF-8">
    <title>${title}</title>
    <link rel="icon" href="/favicon.ico">
    <script src="https://cdn.tailwindcss.com"></script>
  	<script src="/filecoin-listing.js"></script>
  </head>
  <body class="bg-gray-50 p-8">
    <h1 class="text-3xl font-bold mb-6">${title}</h1>
    ${bodyContent}
  </body>
  </html>`;
}

export function renderSnapshotCardTemplate(key: string, base: string, fileSize: string, uploaded: Date, snap_type: string): string {
	return `
    <div class="snapshot-card bg-white shadow rounded-xl p-4 flex flex-col" data-key="${key}">
      <h2 class="font-mono text-sm truncate mb-2">https://forest-archive.chainsafe.dev/archive/${key}</h2>
        <div class="flex justify-between text-xs text-gray-500 mb-4">
    		<span>${fileSize}</span>
    		<span>Uploaded: ${uploaded.toLocaleString('en-US', { timeZone: 'UTC', hour12: false })}</span>
  		</div>
      <div class="mt-auto flex gap-2">
        <a class="flex-1 text-center bg-blue-600 text-white px-3 py-2 rounded-lg text-sm hover:bg-blue-700"
            href="${base}">
        Download
        </a>
        <button class="text-sm border px-3 py-2 rounded-lg hover:bg-gray-100"
        	data-sha256-url="${snap_type == "v2" ? base : base.replace(".zst", "")}.sha256sum"
        	onclick="revealSha(this)">
  		  SHA256
		    </button>
        <button class="${snap_type === "v2" ? "" : "hidden"} text-sm border px-3 py-2 rounded-lg hover:bg-gray-100"
        	data-meta-url="${base}.metadata.json"
        	onclick="revealMeta(this)">
  		  Meta
		    </button>
      </div>
      <pre class="sha256-content hidden mt-2 bg-gray-100 p-2 rounded text-xs overflow-x-auto"></pre>
      <pre class="meta-content hidden mt-2 bg-gray-100 p-2 rounded text-xs overflow-x-auto"></pre>
    </div>
  `;
}

export function renderSnapshotsHomePage(): string {
	return `
<!DOCTYPE html>
<body>
    <h1>Filecoin Snapshots Archive</h1>
    <ul>
      <li><a href="/list/calibnet/latest-v2">Calibnet Latest V2</a></li>
      <li><a href="/list/calibnet/latest">Calibnet Latest</a></li>
      <li><a href="/list/mainnet/latest">Mainnet Latest</a></li>
      <li><a href="/list/calibnet/diff">Calibnet Diff</a></li>
      <li><a href="/list/mainnet/diff">Mainnet Diff</a></li>
      <li><a href="/list/calibnet/lite">Calibnet Lite</a></li>
      <li><a href="/list/mainnet/lite">Mainnet Lite</a></li>
    </ul>
</body>
</html>
`;
}
