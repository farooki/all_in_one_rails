# All In One Rails

A full-stack Ruby on Rails 8 application with PostgreSQL, Hotwire, and the Solid Stack for background jobs, caching, and WebSockets.

---

## Technology Stack

| Layer | Technology | Version |
|---|---|---|
| Language | Ruby | 3.4.6 |
| Framework | Ruby on Rails | 8.1.3 |
| Database | PostgreSQL | 17.6 |
| ORM | Active Record | (bundled with Rails) |
| Primary Keys | UUID (`pgcrypto`) | — |
| Asset Pipeline | Propshaft | latest |
| JavaScript | Importmap + Stimulus | latest |
| Realtime | Turbo (Hotwire) | latest |
| WebSockets | Solid Cable | latest |
| Background Jobs | Solid Queue | latest |
| Caching | Solid Cache | latest |
| Web Server | Puma | >= 5.0 |
| HTTP Accelerator | Thruster | latest |
| Image Processing | image_processing | ~> 1.2 |
| Deployment | Kamal | latest |

### Development tooling

| Tool | Purpose |
|---|---|
| `debug` | Ruby debugger |
| `bundler-audit` | Gem vulnerability scanning |
| `brakeman` | Static security analysis |
| `rubocop-rails-omakase` | Opinionated Ruby linting |
| `web-console` | In-browser Rails console on error pages |

---

## Development Setup

### Option 1 — Dev Container (recommended)

The project ships with a fully configured Dev Container that provides Ruby, Node.js, and PostgreSQL 18 with zero local installation required. You need either:

- [VS Code](https://code.visualstudio.com/) + [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers), or
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) + the [Dev Container CLI](https://github.com/devcontainers/cli)

**Steps:**

1. Clone the repository:
   ```bash
   git clone <repo-url>
   cd all_in_one_rails
   ```

2. Open in VS Code and click **Reopen in Container** when prompted, or run:
   ```
   Dev Containers: Reopen in Container
   ```
   from the command palette (`Cmd+Shift+P` / `Ctrl+Shift+P`).

3. VS Code will build the containers (first time takes a few minutes), then automatically run:
   ```bash
   bundle install && bin/rails db:prepare
   ```

4. Start the server:
   ```bash
   bin/rails server
   ```
   The app will be available at [http://localhost:3000](http://localhost:3000).

**What the Dev Container provides:**

- Ruby 3.4.6 (via `ruby:3.4.6-bookworm`)
- Node.js 20 LTS
- PostgreSQL 18 service (hostname `db`, user/password `postgres`)
- Bundler gem cache persisted across rebuilds
- VS Code extensions: Ruby LSP, Solargraph, Rails, Prettier, GitLens, PostgreSQL explorer

**Container environment variables** (set automatically in `docker-compose.yml`):

| Variable | Value |
|---|---|
| `DB_HOST` | `db` |
| `DB_USERNAME` | `postgres` |
| `DB_PASSWORD` | `postgres` |

---

### Option 2 — Local Setup

**Prerequisites:**

- Ruby 3.4.6 (recommended via [rbenv](https://github.com/rbenv/rbenv) or [mise](https://mise.jdx.dev/))
- PostgreSQL 18
- Node.js 20+
- Bundler

**Steps:**

1. Install dependencies:
   ```bash
   bundle install
   ```

2. Configure the database connection via environment variables (or use the defaults — see `config/database.yml`):
   ```bash
   export DB_HOST=localhost
   export DB_USERNAME=postgres
   export DB_PASSWORD=postgres
   ```

3. Create and migrate the database:
   ```bash
   bin/rails db:prepare
   ```

4. Start the server:
   ```bash
   bin/rails server
   ```

---

## Database

The app uses PostgreSQL with UUID primary keys across all tables, enabled via the `pgcrypto` extension.

The initial migration (`db/migrate/20260521000001_enable_uuids.rb`) enables the extension. All subsequent models automatically use UUIDs as primary keys — no extra configuration needed per model.

**Reset the database:**
```bash
bin/rails db:reset
```

**Run migrations:**
```bash
bin/rails db:migrate
```

---

## Testing

```bash
bin/rails test
```

**Security checks:**
```bash
bundle exec brakeman
bundle exec bundler-audit check --update
```

**Linting:**
```bash
bundle exec rubocop
```

---

## Deployment

This app is configured for deployment via [Kamal](https://kamal-deploy.org/). See `config/deploy.yml` for server and image configuration.

```bash
kamal deploy
```
