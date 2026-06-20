class ApplicationClickhouseRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to database: { writing: :clickhouse, reading: :clickhouse } if ENABLE_CLICKHOUSE
end
