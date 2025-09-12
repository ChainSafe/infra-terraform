// eslint-disable-next-line @typescript-eslint/no-unused-vars
function filterSnapshots() {
  const query = document.getElementById('searchBox').value.toLowerCase();
  document.querySelectorAll('.snapshot-card').forEach(card => {
    card.style.display = card.dataset.key.toLowerCase().includes(query) ? 'flex' : 'none';
  });
}

// eslint-disable-next-line @typescript-eslint/no-unused-vars
async function revealSha(button) {
  const card = button.closest('.snapshot-card');
  const pre = card.querySelector('.sha256-content');
  const isHidden = pre.classList.contains('hidden');
  if (isHidden) {
    const errMessage = 'Snapshot is not validated yet';
    try {
      let resp = await fetch(button.dataset.sha256Url);
      if (!resp.ok) {
        // Try again with an old format
        resp = await fetch(button.dataset.sha256Url.replace('.zst', ''));
      }
      let sha256sum = await resp.text();
      pre.textContent = resp.ok ? sha256sum.split(' ')[0] : errMessage;
    } catch {
      pre.textContent = errMessage;
    }
    pre.classList.remove('hidden');
  } else {
    pre.classList.add('hidden');
  }
}

// eslint-disable-next-line @typescript-eslint/no-unused-vars
async function revealMeta(button) {
  const card = button.closest('.snapshot-card');
  const pre = card.querySelector('.meta-content');
  const isHidden = pre.classList.contains('hidden');
  const errMessage = 'Metadata is not available in this version';
  if (isHidden) {
    try {
      const resp = await fetch(button.dataset.metaUrl);
      const json = await resp.json();
      pre.textContent = resp.ok ? JSON.stringify(json, null, 2) : errMessage;
    } catch {
      pre.textContent = errMessage;
    }
    pre.classList.remove('hidden');
  } else {
    pre.classList.add('hidden');
  }
}
