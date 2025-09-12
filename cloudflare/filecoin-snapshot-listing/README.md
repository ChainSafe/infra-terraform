# Filecoin Snapshot listing worker

This worker acts on endpoints at `https://forest-archive.chainsafe.dev/list**`
and will list object `latest` prefixes for both chains.

# Local deployment

First, login to Cloudflare with `wrangler login`.
Then, use `wrangler dev --remote` to deploy a local version of this worker
which will use the `infra-team-filecoin-archive-dev` bucket
rather than the production `infra-team-filecoin-archive` bucket.
Merging changes to this worker will automatically deploy them.
