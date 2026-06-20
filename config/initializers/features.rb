ENABLE_CLICKHOUSE = false

if ENABLE_CLICKHOUSE
  ActiveRecord::Base.configurations = ActiveRecord::Base.configurations.configurations + [
    ActiveRecord::DatabaseConfigurations::HashConfig.new(
      Rails.env,
      "clickhouse",
      {
        "adapter"  => "clickhouse",
        "database" => ENV.fetch("CLICKHOUSE_DATABASE", "all_in_one_rails"),
        "host"     => ENV.fetch("CLICKHOUSE_HOST", "localhost"),
        "port"     => ENV.fetch("CLICKHOUSE_PORT", "8123").to_i,
        "username" => ENV.fetch("CLICKHOUSE_USERNAME", "default"),
        "password" => ENV.fetch("CLICKHOUSE_PASSWORD", "")
      }
    )
  ]
end
