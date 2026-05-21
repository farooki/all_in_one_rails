namespace :rename do
  desc <<~DESC
    Rename this project throughout the entire codebase.

    Usage:
      bin/rails rename:project[new_name]          # interactive confirmation
      bin/rails rename:project[new_name,force]    # skip confirmation

    The new_name must be in snake_case (e.g. my_cool_app).

    What gets updated:
      - Ruby module names  (AllInOneRails → NewName)
      - Database names     (all_in_one_rails_development → ...)
      - Vue mount id       (#all_in_one_rails → #new_name)
      - Docker volumes / devcontainer name
      - README, CLAUDE.md, package.json, deploy config
      - Dockerfile WORKDIR path
      - Every config, view, JS, Vue, and ERB file in the project
  DESC
  task :project, [:new_name, :force] => :environment do |_t, args|
    # ── Resolve old name variants ───────────────────────────────
    old_snake  = "all_in_one_rails"
    old_pascal = "AllInOneRails"
    old_kebab  = "all-in-one-rails"
    old_human  = "All In One Rails"

    # ── Validate + normalise new name ──────────────────────────
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
      abort "ERROR: New name is identical to the current name. Nothing to do."
    end

    new_pascal = new_snake.split("_").map(&:capitalize).join
    new_kebab  = new_snake.tr("_", "-")
    new_human  = new_snake.split("_").map(&:capitalize).join(" ")

    # ── Print summary ───────────────────────────────────────────
    puts ""
    puts "  Project rename"
    puts "  " + "─" * 52
    puts "  snake_case  :  #{old_snake}  →  #{new_snake}"
    puts "  PascalCase  :  #{old_pascal}  →  #{new_pascal}"
    puts "  kebab-case  :  #{old_kebab}  →  #{new_kebab}"
    puts "  Human       :  #{old_human}  →  #{new_human}"
    puts ""

    # ── Confirm unless forced ───────────────────────────────────
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
      [old_pascal, new_pascal],
      [old_kebab,  new_kebab],
      [old_human,  new_human],
      [old_snake,  new_snake],
    ]

    # ── Files to process ───────────────────────────────────────
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
      .select  { |f| File.file?(f) }
      .reject  { |f| skip_files.any? { |s| File.basename(f) == s } }
      .reject  { |f| skip_dirs.any?  { |d| f.start_with?("#{d}/") || f.start_with?(".#{d}/") } }
      .sort

    # ── Process each file ───────────────────────────────────────
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

    # ── Summary ─────────────────────────────────────────────────
    puts ""
    puts "  " + "─" * 52
    puts "  #{changed.size} file(s) updated."

    if skipped.any?
      puts ""
      puts "  Skipped (could not read):"
      skipped.each { |s| puts "    #{s}" }
    end

    puts ""
    puts "  Next steps:"
    puts "    1.  bundle install"
    puts "    2.  npm install"
    puts "    3.  bin/rails db:drop db:create db:migrate"
    puts "    4.  Rebuild the devcontainer  (Rebuild Container in VS Code)"
    puts "    5.  bin/dev"
    puts ""
  end
end
