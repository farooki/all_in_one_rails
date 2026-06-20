require "test_helper"

class FeaturesInitializerTest < ActiveSupport::TestCase
  test "ENABLE_CLICKHOUSE constant is defined" do
    assert defined?(ENABLE_CLICKHOUSE), "ENABLE_CLICKHOUSE must be defined"
  end

  test "ENABLE_CLICKHOUSE is a boolean" do
    assert_includes [ true, false ], ENABLE_CLICKHOUSE
  end

  test "ENABLE_CLICKHOUSE is false by default" do
    assert_equal false, ENABLE_CLICKHOUSE
  end
end
