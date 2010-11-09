require 'test_helper'

class User
  attr_accessor :name, :username
  
  include ADMapper::User
  set_group_class Group
end

class Group
  attr_accessor :name
  include ADMapper::Group
  
end

class Customer
  attr_accessor :login, :first_name, :last_name, :full_name
  include ADMapper::User
  
  def ad_map
    {:login => :samaccountname, :last_name => :sn, :first_name => :givenname, :full_name => :displayname
    
      }
  end

end

class UserTest < Test::Unit::TestCase
  def teardown
    ADMapper::Configuration.connection_info = nil
    ADMapper::Connection.current_connection = nil    
  end
  
  def test_should_not_find_homer
     ADMapper::Configuration.connection_info = CONFIG_OPTS

     assert_nil User.find_in_ad_by_username("homer")
   end

   def test_should_find_user
     ADMapper::Configuration.connection_info = CONFIG_OPTS
     user =  User.find_in_ad_by_username(USER)
     assert user
   end

   def test_should_find_hoganbp_and_assign_username_to_returned_object
     ADMapper::Configuration.connection_info = CONFIG_OPTS
     user =  User.find_in_ad_by_username(USER)
     assert_equal USER, user.username.downcase
   end

   def test_should_find_hoganbp_via_instance_method
     ADMapper::Configuration.connection_info = CONFIG_OPTS

     user = User.new
     user.username = USER
     assert user.find_in_ad
   end

   def test_should_assign_username_via_instance_method
     ADMapper::Configuration.connection_info = CONFIG_OPTS

     user = User.new
     user.username = USER
     user.find_in_ad
     assert_equal USER, user.username.downcase
   end

   def test_should_have_the_ad_user_in_the_user_instance
     ADMapper::Configuration.connection_info = CONFIG_OPTS
     user = User.new
     user.username = USER
     user.find_in_ad
     assert_not_nil user.ad_user
     puts user.ad_user[:groups] #["memberOf"]
   end

   def test_should_auth_user
     ADMapper::Configuration.connection_info = CONFIG_OPTS
     pwd = CONFIG_OPTS[:password]
     user = CONFIG_OPTS[:username]
     assert User.authenticate_with_active_directory(user, pwd)

   end

   def test_should_get_attributes_on_a_mapped_user
     ADMapper::Configuration.connection_info = CONFIG_OPTS
     c = Customer.find_in_ad_by_username(USER)
     assert_equal c.full_name, c.ad_user.displayname.to_s
     assert_equal c.first_name, c.ad_user.givenname.to_s
     assert_equal c.last_name, c.ad_user.sn.to_s
     assert_equal c.login, c.ad_user.samaccountname.to_s

   end

   def test_user_is_member_of_group
     ADMapper::Configuration.connection_info = CONFIG_OPTS
     user = User.new
     user.username = USER
     user.find_in_ad
     assert user.member_of?(GROUP)
   end

   def test_user_has_groups
     ADMapper::Configuration.connection_info = CONFIG_OPTS
     user = User.new
     user.username = USER
     user.find_in_ad
     assert user.groups.length > 0
   end
  
  
end