# Agent instructions (tinhub)

tinhub hosts tit repositories: the tit protocol for clone, fetch and push, accounts and keys, reviews, a JSON API,
workers, the runner and a web UI — all written in Tin. It lives in its own repository; the language and toolchain are
in [usetin/tin](https://github.com/usetin/tin), version control in [usetin/tit](https://github.com/usetin/tit), the
documentation (the design notes) in [usetin/docs](https://github.com/usetin/docs).

## Setup and checks

```sh
git clone git@github.com:usetin/tin.git ../tin   # or anywhere: TIN=/path/to/tin
git clone git@github.com:usetin/tit.git tit      # the test programs import tit/ relatively
make build        # bin/tinhub
make test         # unit tests and the build everywhere
```

- The Postgres checks run when `TINHUB_TEST_DB` is set (`host:port/name`, plus `TINHUB_TEST_DB_USER` and
  `TINHUB_TEST_DB_PASSWORD`); CI runs them against a Postgres service, with MinIO for the bucket and the
  runner's user namespaces for the sandbox. The database is emptied: never point it at one you need.
- Go is used by two test fakes (`tests/fakes/s3sig`, `tests/fakes/tinhub_hooks`); without Go those parts skip.
- `TIT_ROOT` points at the tit checkout (`tit/` by default); the protocol tests build tit from it.
- `TINHUB_TEST_INDEX_TIN=1` adds the symbol index check over the tin repository (about a minute).

## Rules

- Style follows the Tin language: edition 1, tabs, one declaration per line; `../tin/tin fmt` formats.
- The design is `design/tinhub.md` in usetin/docs; a change to the schema, the API or the protocol says so in
  the message and keeps that page in step. `db/migrations/` is append-only: a migration is never edited once merged.
- The web UI has its own unit tests (`node --test web/test/*.test.js`, run by the suite).
