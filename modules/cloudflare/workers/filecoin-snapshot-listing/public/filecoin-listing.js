function filterSnapshots() {
  const query = document.getElementById('searchBox').value.toLowerCase();
  document.querySelectorAll('.snapshot-card').forEach(card => {
    card.style.display = card.dataset.key.toLowerCase().includes(query) ? 'flex' : 'none';
  });
}

async function revealSha(button) {
  const card = button.closest('.snapshot-card');
  const pre = card.querySelector('.sha256-content');
  const isHidden = pre.classList.contains('hidden');
  if (isHidden) {
    try {
      const resp = await fetch(button.dataset.sha256Url);
      let sha256sum = await resp.text();
      pre.textContent = resp.ok ? sha256sum.split(' ')[0] : 'Failed to load sha256sum';
    } catch {
      pre.textContent = 'Failed to load sha256sum';
    }
    pre.classList.remove('hidden');
  } else {
    pre.classList.add('hidden');
  }
}

async function revealMeta(button) {
  const card = button.closest('.snapshot-card');
  const pre = card.querySelector('.meta-content');

  if (pre.classList.contains('meta-content')) {
    try {
      const resp = await fetch(button.dataset.metaUrl);
      const json = await resp.json();
      pre.textContent = JSON.stringify(json, null, 2);
    } catch (e) {
      pre.textContent = 'Failed to load meta';
    }
    pre.classList.remove('hidden');
  } else {
    pre.classList.add('hidden');
  }
}
