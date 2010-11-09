module ADMapper
  
  module User
    
    def self.included(model)
      model.class_eval do
        extend  ADMapper::User::ClassMethods
        include ADMapper::User::InstanceMethods
        attr_accessor :ad_user
      end
    
    end
    
    module InstanceMethods
      
      # Returns the groups for a user.
      def groups
        groups = []
        
         search_filter = Net::LDAP::Filter.eq("sAMAccountName", self.ad_user.samaccountname.first)
            ad_connection = ADMapper::Connection.current_connection
            ad_connection.search(:base => ADMapper::Connection.treebase,
                                   :filter => search_filter) do |entry|

                                     entry.each do |attribute, values|      
                                     if attribute.to_s.match(/memberof/)
                                          values.each do |value|
                                            a = value.split(',')
                                            md = a[0].match(/CN=(.+)/)

                                            groups << md[1]
                                          end
                                        end
                                     end
         end
         
         groups.collect do |g|
           self.class.group_class.find_in_ad_by_name(g)
         end.compact
         
         
      end
      
  
      
      def member_of?(group)
        group_member = false
        
        search_filter = Net::LDAP::Filter.eq("sAMAccountName", self.ad_user.samaccountname.first)
           ad_connection = ADMapper::Connection.current_connection
           ad_connection.search(:base => ADMapper::Connection.treebase,
                                  :filter => search_filter) do |entry|
                                    
                                    entry.each do |attribute, values|      
                                    if attribute.to_s.match(/memberof/)
                                         values.each do |value|
                                           a = value.split(',')
                                           md = a[0].match(/CN=(.+)/)

                                           # user is a member of the right group
                                           if md[1] == group
                                             group_member = true
                                           end
                                         end
                                       end
                                    end
        end
        group_member
        
      end
      
      
      # finds a user in active directory using the internal key.
      # Defaults to username
      def find_in_ad(options = {:key => :username})
        username = send(options[:key])
        ad_user = self.class.ad_query_by_username(username)
        return nil if ad_user.nil?
        self.map_user_from_ad(ad_user)
        true
      end
      
      # maps the ad_user's attributes to your class' attributes
      #. Implement the ad_map method in your own class to control how fields map.
      def map_user_from_ad(ad_user)
         self.ad_map.each do |user_object_field, ad_object_field|           
           self.send("#{user_object_field}=", ad_user.send(ad_object_field).to_s)
        end
        self.ad_user = ad_user
      end     
    
      # Default mapping of user object to active directory.
      # You will most likely want to implement this in your own class
      # instead of using this very basic default.
      # Simply map your model (keys of the hash) to ActiveDirectory (values of the hash)
      #
      #   def ad_map
      #     {
      #       :username => :samaccountname,
      #       :full_name => :displayname
      #     }
      #   end
      def ad_map
        {:username => :samaccountname}
      end

    end
    
    module ClassMethods
       attr_accessor :group_class
       
       def set_group_class(group_class)
         self.group_class = group_class
       end
       
       # Authenticating users:
       # Don't do this. Taking someone's password and passing it 
       # on to Active Directory is just stupid. Use CAS, Shibboleth, or 
       # something else that prevents your app from ever seeing a user's password. 
       # If you insist on doing this, use SSL, filter the password out of your logs,
       # and pray. This will let you do what you want
       # 
       #    User.authenticate_with_active_directory("homer", "1234") 
       # 
       # It'll return true or false. It won't return a user. I assume you'll be wrapping this call in something else that will fetch the user object from your local DB.
       def authenticate_with_active_directory(username, password)
         auth_ldap = ADMapper::Connection.current_connection.dup.bind_as(
          :filter => Net::LDAP::Filter.eq( "sAMAccountName", username ),
          :base => ADMapper::Connection.treebase,
          :password => password
         )
       
       end
       
       # Find a user in AD by the given username
       # Calls #map_user_from_ad on the returned results
       # so you can manage it yourself.
       def find_in_ad_by_username(username)
         ad_user = ad_query_by_username(username)
         return nil if ad_user.nil?
         
         user = self.new
         user.map_user_from_ad(ad_user)
         user
       end
  
       # find a user in AD by the given userame.
       # Connects if not connected
       # Returns an AD object
       def ad_query_by_username(username)
       
         user = nil
         search_filter = Net::LDAP::Filter.eq( "sAMAccountName", username ) 
            ad_connection = ADMapper::Connection.current_connection
            ad_connection.search(:base => ADMapper::Connection.treebase,
                                   :filter => search_filter, 
                                   :attributes => ['dn','sAMAccountName','displayname','SN','givenName']) do |ad_user|      
             user = ad_user
         end
         user
       end
     
    end
  end
end