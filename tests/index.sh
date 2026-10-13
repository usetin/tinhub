#!/bin/sh
# The symbol index on the Tin repository itself (#1020), against TINHUB_TEST_DB. Usage: index.sh INDEX_TIN. Every
# tracked file is pushed as one commit and indexed inside the index job's budget (2m, 256mb: index.Within and
# index.Memory), then an edit of one package is pushed and must re-index only that package.
set -eu
driver=$1
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
root=${TIN_ROOT:?TIN_ROOT must point at a tin checkout}
(cd "$root" && git ls-files) > "$tmp/files"
TIN_ROOT=$root "$driver" "$tmp/files" "$root" "$tmp/node" > "$tmp/out" 2>&1 || { cat "$tmp/out"; echo "FAIL tinhub index: the tin repository"; exit 1; }
grep '^full: ' "$tmp/out"
grep '^incremental: ' "$tmp/out"
grep -q '^incremental: .* reindexed=1 ' "$tmp/out" || { cat "$tmp/out"; echo "FAIL tinhub index: the incremental push re-indexed more than its package"; exit 1; }
grep -q '^incremental found Added: 1$' "$tmp/out" || { cat "$tmp/out"; echo "FAIL tinhub index: the incremental push's new function"; exit 1; }
grep -q '^commits held after prune: 1$' "$tmp/out" || { cat "$tmp/out"; echo "FAIL tinhub index: prune"; exit 1; }
echo "PASS tinhub index (the Tin repository in the job's budget, incremental)"
