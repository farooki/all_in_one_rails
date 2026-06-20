# CLAUDE.md

This file gives Claude Code the context it needs to work effectively in this repository.

## Technology Stack

| Layer | Technology | Version |
|---|---|---|
| Language | Ruby | 3.4.6 |
| Framework | Ruby on Rails | 8.1.3 |
| Database | PostgreSQL | 17.6 |
| ORM adapter | `pg` gem | 1.6.3 |
| Primary keys | UUID via `pgcrypto` | — |
| Asset pipeline | Propshaft | 1.3.2 |
| CSS | Tailwind CSS | 4.3.1 |
| JavaScript | Vite + Vue 3 + Stimulus | Vite 8.0.16 / Vue 3.5.38 |
| State management | Pinia | 3.0.4 |
| Client routing | Vue Router | 5.1.0 |
| Realtime / SPA | Turbo (Hotwire) | 2.0.23 |
| WebSockets | Solid Cable | 4.0.0 |
| Background jobs | Solid Queue | 1.4.0 |
| Caching | Solid Cache | 1.0.10 |
| Web server | Puma | 8.0.2 |
| HTTP accelerator | Thruster | 0.1.21 |
| Image processing | image_processing + mini_magick | 2.0.2 / 5.3.1 |
| Deployment | Kamal | 2.12.0 |
| Analytics (optional) | ClickHouse via `clickhouse-activerecord` | 1.6.7 (feature-flagged) |

## Project Layout (key paths)

- `app/javascript/` — Vite entry point, Vue components, router, stores, styles
- `app/javascript/entrypoints/application.js` — boots Vue, Pinia, Stimulus, Turbo
- `app/javascript/components/DefaultHomePage.vue` — home page component
- `config/database.yml` — PostgreSQL config; reads `DB_HOST`, `DB_USERNAME`, `DB_PASSWORD` from env
- `config/initializers/features.rb` — feature flags (`ENABLE_CLICKHOUSE`)
- `db/migrate/20260521000001_enable_uuids.rb` — enables `pgcrypto`; all tables use UUID primary keys
- `vite.config.ts` — Vite build config (Ruby plugin, Vue, Tailwind)
- `vitest.config.ts` — Vitest config for frontend tests (separate from vite.config.ts)
- `Procfile.dev` — runs Rails + Vite dev server via foreman (`bin/dev`)
- `.devcontainer/` — Dev Container config (docker-compose, Dockerfile, devcontainer.json)
- `.github/workflows/ci.yml` — CI pipeline (scan_ruby, scan_js, lint, backend-tests, frontend-tests)
- `test/` — Minitest backend tests
- `test/javascript/` — Vitest frontend tests

## Dev Container

The project ships with a Dev Container. Open it in VS Code with **Reopen in Container**.

### What it provides

- Ruby 3.4.6, Node.js 20, bundler
- PostgreSQL 17.6 as a sidecar service (hostname `db`, user/password `postgres`)
- Persistent bundler gem cache (named Docker volume)

### Environment variables set automatically

| Variable | Value |
|---|---|
| `DB_HOST` | `db` |
| `DB_USERNAME` | `postgres` |
| `DB_PASSWORD` | `postgres` |

### postCreateCommand

After the container builds, VS Code automatically runs:
```bash
bundle config set default_cli_command install --global && bundle install && npm install && bin/rails db:prepare
```

### Starting the development server

```bash
bin/dev
```

This uses foreman to run both `bin/rails server` and the Vite dev server concurrently. CSS and JS hot-reload automatically.

## Debugging with Claude Code inside the Dev Container

### 1. Enter the container from the terminal

If you're already in the VS Code Dev Container terminal, you're inside. If using Claude Code from outside:

```bash
docker exec -it all_in_one_rails_devcontainer-app-1 bash
```

Then navigate to the workspace:
```bash
cd /workspaces/all_in_one_rails
```

### 2. Run Claude Code

Inside the container shell:
```bash
claude
```

Claude Code is billed to your account and runs with full access to the workspace files, Rails commands, and the PostgreSQL service.

### 3. Useful commands for debugging sessions

```bash
# Run backend tests (Minitest + SimpleCov)
bin/rails test

# Run frontend tests (Vitest)
npm test

# Run frontend tests in watch mode
npm run test:watch

# Open a Rails console connected to the dev database
rails console

# Check database connectivity
rails db:migrate:status

# Run security scans
bin/brakeman --no-pager
bin/bundler-audit check --update

# Lint
bin/rubocop
```

### 4. Remote debugging (VS Code + debug gem)

`bin/dev` already sets these env vars:
```
RUBY_DEBUG_OPEN=true
RUBY_DEBUG_LAZY=true
```

This lets the `debug` gem accept remote connections. To attach from VS Code:

1. Install the **VSCode rdbg Ruby Debugger** extension.
2. Add a launch config to `.vscode/launch.json`:
   ```json
   {
     "version": "0.2.0",
     "configurations": [
       {
         "type": "rdbg",
         "name": "Attach to Rails (dev container)",
         "request": "attach",
         "debugPort": "localhost:38698"
       }
     ]
   }
   ```
3. Start the server with `bin/dev`, then place a `debugger` call anywhere in Ruby code.
4. Press **F5** in VS Code to attach.

## Common Rails Commands

```bash
# Generate a model (UUID primary key applied automatically)
rails generate model Post title:string body:text

# Create and run migrations
rails db:migrate

# Seed the database
rails db:seed

# Reset everything
rails db:reset
```

## Testing

### Backend (Minitest)

```bash
bin/rails test                  # run all backend tests
bin/rails test test/models/     # run a specific directory
bin/rails test test/models/application_clickhouse_record_test.rb  # single file
```

Coverage is tracked by **SimpleCov** — report is generated to `coverage/` after every run (gitignored).

### Frontend (Vitest + Vue Test Utils)

```bash
npm test                        # single run
npm run test:watch              # watch mode — reruns on file change
```

Test files live in `test/javascript/` and follow the pattern `**/*.test.{js,ts}`.

Config lives in `vitest.config.ts` (separate from `vite.config.ts` so vite-plugin-ruby doesn't interfere).

### Feature flags

`ENABLE_CLICKHOUSE` is defined in `config/initializers/features.rb`. Set it to `true` to activate the ClickHouse connection and `ApplicationClickhouseRecord` base class.

## CI/CD

GitHub Actions runs five parallel jobs on every PR and push to `main`:

| Job | What it does |
|---|---|
| `scan_ruby` | Brakeman static analysis + bundler-audit gem CVE check |
| `scan_js` | `npm audit --audit-level=high` |
| `lint` | RuboCop with result caching |
| `backend-tests` | Spins up `postgres:17.6`, runs `bin/rails db:test:prepare test` |
| `frontend-tests` | Installs Node deps, runs `npm test` (Vitest) |
