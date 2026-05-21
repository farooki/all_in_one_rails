# All In One Rails

A full-stack Ruby on Rails 8 application with Vue 3, PostgreSQL, Tailwind CSS 4, Hotwire, and the Solid Stack — batteries included, production-ready from day one.

---

## Technology Stack

### Backend

| Layer | Technology | Version |
|---|---|---|
| Language | Ruby | 3.4.6 |
| Framework | Ruby on Rails | 8.1.3 |
| Database | PostgreSQL | 17.6 |
| DB Adapter | pg | 1.6.3 |
| Primary Keys | UUID via `pgcrypto` | — |
| Web Server | Puma | 8.0.1 |
| HTTP Accelerator | Thruster | 0.1.21 |
| Asset Pipeline | Propshaft | 1.3.2 |
| Image Processing | image_processing | 1.14.0 |
| Deployment | Kamal | 2.11.0 |

### Frontend

| Layer | Technology | Version |
|---|---|---|
| UI Framework | Vue.js | 3.5.34 |
| Client Routing | Vue Router | 4.6.4 |
| State Management | Pinia | 2.3.1 |
| CSS | Tailwind CSS | 4.3.0 |
| JS Bundler | Vite | 8.0.14 |
| Vite Rails Bridge | vite_rails | 3.11.0 |

### Hotwire & Realtime

| Technology | Version |
|---|---|
| @hotwired/turbo | 8.0.23 |
| turbo-rails | 2.0.23 |
| @hotwired/stimulus | 3.2.2 |
| stimulus-rails | 1.3.4 |
| Solid Cable (WebSockets) | 3.0.12 |

### Background & Caching

| Technology | Version |
|---|---|
| Solid Queue | 1.4.0 |
| Solid Cache | 1.0.10 |

### Development Tooling

| Tool | Purpose |
|---|---|
| `debug` | Ruby debugger |
| `bundler-audit` | Gem CVE scanning |
| `brakeman` | Static security analysis |
| `rubocop-rails-omakase` | Opinionated Ruby linting |
| `web-console` | In-browser Rails console on error pages |

---

## Development Setup

### Option 1 — Dev Container (recommended)

The project ships with a fully configured Dev Container that provides Ruby, Node.js, and PostgreSQL 17.6 with zero local installation required. You need either:

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

3. VS Code builds the containers (first time takes a few minutes) then automatically runs:
   ```bash
   bundle install && npm install && bin/rails db:prepare
   ```

4. Start the development server:
   ```bash
   bin/dev
   ```
   The app will be available at [http://localhost:3000](http://localhost:3000).

   `bin/dev` uses foreman to run Rails and the Vite dev server concurrently — CSS and JS hot-reload automatically.

**What the Dev Container provides:**

- Ruby 3.4.6 (via `ruby:3.4.6-bookworm`)
- Node.js 20 LTS
- PostgreSQL 17.6 sidecar service (hostname `db`, user/password `postgres`)
- Bundler gem cache persisted across rebuilds (named Docker volume)
- VS Code extensions: Ruby LSP, Solargraph, Rails, Prettier, GitLens, PostgreSQL explorer

**Container environment variables** (set automatically):

| Variable | Value |
|---|---|
| `DB_HOST` | `db` |
| `DB_USERNAME` | `postgres` |
| `DB_PASSWORD` | `postgres` |

---

### Option 2 — Local Setup

**Prerequisites:**

- Ruby 3.4.6 (recommended via [rbenv](https://github.com/rbenv/rbenv) or [mise](https://mise.jdx.dev/))
- PostgreSQL 17.6
- Node.js 20+
- Bundler

**Steps:**

1. Install Ruby and JS dependencies:
   ```bash
   bundle install
   npm install
   ```

2. Configure the database connection (or use the defaults — see `config/database.yml`):
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
   bin/dev
   ```

---

## Database

PostgreSQL with UUID primary keys across all tables, enabled via the `pgcrypto` extension.

The initial migration (`db/migrate/20260521000001_enable_uuids.rb`) enables the extension. All subsequent models generated with `rails generate model` automatically use UUIDs as primary keys.

```bash
bin/rails db:migrate       # run pending migrations
bin/rails db:reset         # drop, recreate, and migrate
bin/rails db:rollback      # roll back one migration
```

---

## Frontend

The frontend is a Vue 3 SPA mounted at `#all_in_one_rails` inside the Rails layout. Vue Router handles all client-side navigation; Rails serves the shell and API.

```
app/javascript/
  entrypoints/
    application.js        ← Vite entry: boots Vue, Pinia, Stimulus, Turbo
  components/
    DefaultHomePage.vue   ← Home page component
  router/
    index.js              ← Vue Router routes
  stores/
    index.js              ← Pinia app store
  styles/
    application.css       ← @import "tailwindcss"
  App.vue                 ← Root component
```

**Build for production:**
```bash
bin/rails vite:build
```

---

## Testing

```bash
bin/rails test                              # all unit & integration tests
bin/rails test:db                          # reset DB then test
```

**Security:**
```bash
bin/brakeman --no-pager                    # static analysis
bin/bundler-audit check --update           # gem CVE check
```

**Linting:**
```bash
bin/rubocop                                # code style
```

---

## Renaming the Project

This is an open-source template. A rake task handles renaming the project throughout the entire codebase in one command.

```bash
bin/rails rename:project[my_new_app]
```

Replace `my_new_app` with your desired name in **snake_case**. The task derives all naming variants automatically:

| Variant | Before | After (example) |
|---|---|---|
| `snake_case` | `all_in_one_rails` | `my_new_app` |
| `PascalCase` | `AllInOneRails` | `MyNewApp` |
| `kebab-case` | `all-in-one-rails` | `my-new-app` |
| Human | `All In One Rails` | `My New App` |

**What gets renamed:**

- Ruby module name (`config/application.rb`)
- Database names (`config/database.yml`)
- Vue mount ID (`#all_in_one_rails`)
- Dev Container name and Docker volume names
- Dockerfile `WORKDIR` path
- `package.json`, `README.md`, `CLAUDE.md`, `deploy.yml`
- Every `.rb`, `.erb`, `.vue`, `.js`, `.ts`, `.yml`, `.json`, `.md` file in the project

The task asks for confirmation before writing. To skip the prompt (e.g. in a script):

```bash
bin/rails rename:project[my_new_app,force]
```

**After renaming, run:**

```bash
bundle install
npm install
bin/rails db:drop db:create db:migrate
# Then rebuild the Dev Container in VS Code
bin/dev
```

---

## CI/CD

GitHub Actions runs four jobs on every pull request and push to `main`:

| Job | What it does |
|---|---|
| `scan_ruby` | Brakeman static analysis + bundler-audit gem CVE check |
| `scan_js` | importmap audit |
| `lint` | RuboCop with result caching |
| `test` | Spins up `postgres:17.6`, runs `bin/rails db:test:prepare test` |

---

## Deployment

Configured for deployment via [Kamal](https://kamal-deploy.org/). See `config/deploy.yml`.

```bash
kamal deploy
```

---

*Developed & owned by **Muneeb Ahmad Farooqi***
