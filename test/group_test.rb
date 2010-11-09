require 'test_helper'


class Group
  attr_accessor :name
  include ADMapper::Group
end

class GroupTest < Test::Unit::TestCase
  
  def teardown
    ADMapper::Configuration.connection_info = nil
    ADMapper::Connection.current_connection = nil    
  end
  
  
  def test_gets_group_by_name
    ADMapper::Configuration.connection_info = CONFIG_OPTS
    
    g = Group.find_in_ad_by_name(GROUP)
    assert_equal GROUP, g.name
  end
  
  def test_gets_group_by_name_returns_nil_with_no_match
    ADMapper::Configuration.connection_info = CONFIG_OPTS
    
    g = Group.find_in_ad_by_name("WEas2xB.")
    assert_nil g
  end
  
  def test_gets_group_by_name_returns_first_record_with_wildcard
    ADMapper::Configuration.connection_info = CONFIG_OPTS
    
    g = Group.find_in_ad_by_name(GROUP[0..3] + "*")
    assert_kind_of Group, g
    
  end
  
  def test_gets_groups_by_name
    ADMapper::Configuration.connection_info = CONFIG_OPTS
    groups = Group.find_all_in_ad_by_name( GROUP[0..3] + "*")
    assert groups.find{|n| n.name == GROUP}
    
    
  end
  
  
end