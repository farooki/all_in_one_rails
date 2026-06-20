require "test_helper"

class ApplicationClickhouseRecordTest < ActiveSupport::TestCase
  test "is abstract" do
    assert ApplicationClickhouseRecord.abstract_class?
  end

  test "inherits from ActiveRecord::Base" do
    assert ApplicationClickhouseRecord < ActiveRecord::Base
  end

  test "uses default postgresql connection when ENABLE_CLICKHOUSE is false" do
    skip "only applies when ENABLE_CLICKHOUSE is false" if ENABLE_CLICKHOUSE

    assert_equal "postgresql", ApplicationClickhouseRecord.connection_db_config.adapter
  end

  test "uses clickhouse connection when ENABLE_CLICKHOUSE is true" do
    skip "only applies when ENABLE_CLICKHOUSE is true" unless ENABLE_CLICKHOUSE

    assert_equal "clickhouse", ApplicationClickhouseRecord.connection_db_config.adapter
  end
end
