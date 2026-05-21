namespace :rename do
  desc <<~DESC
    Rename this project throughout the entire codebase.

    Usage:
      bin/rails rename:project[new_name]          # interactive confirmation
      bin/rails rename:project[new_name,force]    # skip confirmation

    The new_name must be in snake_case (e.g. my_cool_app).
    The current project name is auto-detected from the Rails application module.

    What gets updated:
      - Ruby module name in config/application.rb
      - Database names in config/database.yml
      - Vue mount id (#current_name → #new_name)
      - Dev Container name and Docker volume names
      - README.md, CLAUDE.md, package.json, deploy config
      - Dockerfile WORKDIR path
      - Every .rb, .erb, .vue, .js, .ts, .yml, .json, .md file in the project
      - .git directory is removed so the new project starts with a clean history
  DESC
  task :project, [ :new_name, :force ] => :environment do |_t, args|
    require "fileutils"

    # ── Auto-detect current name from the Rails application module ──
    old_pascal = Rails.application.class.module_parent_name
    old_snake  = old_pascal
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .downcase
    old_kebab  = old_snake.tr("_", "-")
    old_human  = old_snake.split("_").map(&:capitalize).join(" ")

    # ── Validate + normalise new name ──────────────────────────────
    raw = args[:new_name].to_s.strip
    if raw.empty?
      abort <<~MSG
        ERROR: No name supplied.
        Usage: bin/rails rename:project[new_name]
               bin/rails rename:project[my_app]
      MSG
    end

    new_snake = raw
      .downcase
      .gsub(/[^a-z0-9]+/, "_")
      .gsub(/^_+|_+$/, "")

    if new_snake.empty?
      abort "ERROR: '#{raw}' produces an empty snake_case name. Use letters, numbers and underscores."
    end

    if new_snake == old_snake
      abort "ERROR: New name is identical to the current name (#{old_snake}). Nothing to do."
    end

    new_pascal = new_snake.split("_").map(&:capitalize).join
    new_kebab  = new_snake.tr("_", "-")
    new_human  = new_snake.split("_").map(&:capitalize).join(" ")

    # ── Print summary ───────────────────────────────────────────────
    puts ""
    puts "  Project rename"
    puts "  " + "─" * 54
    puts "  Detected    :  #{old_human} (#{old_snake})"
    puts "  " + "─" * 54
    puts "  snake_case  :  #{old_snake}  →  #{new_snake}"
    puts "  PascalCase  :  #{old_pascal}  →  #{new_pascal}"
    puts "  kebab-case  :  #{old_kebab}  →  #{new_kebab}"
    puts "  Human       :  #{old_human}  →  #{new_human}"
    puts ""
    puts "  .git directory will be removed for a clean history."
    puts ""

    # ── Confirm unless forced ────────────────────────────────────────
    unless args[:force].to_s == "force"
      print "  Continue? [y/N]  "
      $stdout.flush
      answer = $stdin.gets.to_s.strip.downcase
      unless answer == "y"
        puts "  Aborted."
        exit 0
      end
      puts ""
    end

    # ── Ordered substitutions (PascalCase first to avoid partial hits) ──
    subs = [
      [ old_pascal, new_pascal ],
      [ old_kebab,  new_kebab ],
      [ old_human,  new_human ],
      [ old_snake,  new_snake ]
    ]

    # ── Files to process ────────────────────────────────────────────
    globs = %w[
      app/**/*.rb
      app/**/*.erb
      app/**/*.vue
      app/**/*.js
      app/**/*.ts
      app/**/*.css
      app/**/*.json
      config/**/*.rb
      config/**/*.yml
      config/**/*.yaml
      config/**/*.json
      lib/**/*.rb
      lib/**/*.rake
      test/**/*.rb
      test/**/*.erb
      db/**/*.rb
      .devcontainer/**/*.json
      .devcontainer/**/*.yml
      .devcontainer/**/*.yaml
      .github/**/*.yml
      .github/**/*.yaml
    ]

    explicit_files = %w[
      Gemfile
      package.json
      vite.config.ts
      Procfile.dev
      README.md
      CLAUDE.md
      .devcontainer/Dockerfile
    ]

    skip_files = %w[
      Gemfile.lock
      package-lock.json
    ]

    skip_dirs = %w[
      node_modules
      vendor
      public
      tmp
      log
      storage
      .git
    ]

    files = globs
      .flat_map { |g| Dir.glob(g, File::FNM_DOTMATCH) }
      .concat(explicit_files)
      .uniq
      .select { |f| File.file?(f) }
      .reject { |f| skip_files.any? { |s| File.basename(f) == s } }
      .reject { |f| skip_dirs.any?  { |d| f.start_with?("#{d}/") || f.start_with?(".#{d}/") } }
      .sort

    # ── Process each file ────────────────────────────────────────────
    changed = []
    skipped = []

    files.each do |file|
      begin
        original = File.read(file, encoding: "utf-8")
      rescue => e
        skipped << "#{file} (#{e.message})"
        next
      end

      updated = original.dup
      subs.each { |from, to| updated.gsub!(from, to) }

      next if updated == original

      File.write(file, updated, encoding: "utf-8")
      changed << file
      puts "  ✓  #{file}"
    end

    # ── Remove .git for a clean history ─────────────────────────────
    puts ""
    if Dir.exist?(".git")
      FileUtils.rm_rf(".git")
      puts "  ✓  .git removed"
    else
      puts "  –  .git not found, skipping"
    end

    # ── Summary ──────────────────────────────────────────────────────
    puts ""
    puts "  " + "─" * 54
    puts "  #{changed.size} file(s) updated."

    if skipped.any?
      puts ""
      puts "  Skipped (could not read):"
      skipped.each { |s| puts "    –  #{s}" }
    end

    puts ""
    puts "  Next steps:"
    puts "    1.  git init && git add -A && git commit -m 'Initial commit: #{new_human}'"
    puts "    2.  bundle install"
    puts "    3.  npm install"
    puts "    4.  bin/rails db:drop db:create db:migrate"
    puts "    5.  Rebuild the Dev Container  (VS Code: Rebuild Container)"
    puts "    6.  bin/dev"
    puts ""
  end
end
