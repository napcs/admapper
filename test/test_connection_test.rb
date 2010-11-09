require 'test_helper'

class ConnectionTest < Test::Unit::TestCase



  def teardown
    ADMapper::Configuration.connection_info = nil
    ADMapper::Connection.current_connection = nil    
  end

  def test_should_raise_exception_with_no_connection
    assert_raise(ADMapper::ConfigurationMissingError) { User.find_in_ad_by_username(USER)}
  end

  def test_should_set_and_get_connect_info
    ADMapper::Configuration.connection_info = CONFIG_OPTS
    assert_equal CONFIG_OPTS, ADMapper::Configuration.connection_info
  end

end