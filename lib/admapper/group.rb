module ADMapper
  
  module Group
    
    def self.included(model)
      model.class_eval do
        extend  ADMapper::Group::ClassMethods
        include ADMapper::Group::InstanceMethods
        attr_accessor :ad_group
      end
    
    end
    
    module InstanceMethods
            
      # maps the ad_user's attributes to your class' attributes
      #. Implement the ad_map method in your own class to control how fields map.
      def map_group_from_ad(ad_group)
         self.ad_map.each do |group_object_field, ad_object_field|           
           self.send("#{group_object_field}=", ad_group.send(ad_object_field).to_s)
        end
        self.ad_group = ad_group
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
        {:name => :cn}
      end
    end
    
    module ClassMethods
      
      def find_in_ad_by_name(groupname)
        attrs = [ "cn", "ou" , "objectClass"]
        filter = Net::LDAP::Filter.eq( "objectClass", "group" )
        name_filter = Net::LDAP::Filter.eq( "cn", groupname )
        ad_connection = ADMapper::Connection.current_connection
        ad_group = nil
        ad_connection.search( :base => ADMapper::Connection.treebase,
                             :attributes => attrs, 
                             :filter => filter & name_filter ) do |entry|
                             if entry
                                ad_group = self.new
                                ad_group.map_group_from_ad(entry)
                                break
                             end                
        end
        ad_group
        
      end
      def find_all_in_ad_by_name(groupname)
      
        attrs = [ "cn", "ou" , "objectClass"]
        filter = Net::LDAP::Filter.eq( "objectClass", "group" )
        name_filter = Net::LDAP::Filter.eq( "cn", groupname )
        ad_connection = ADMapper::Connection.current_connection
        ad_groups = []
        
        ad_connection.search( :base => ADMapper::Connection.treebase,
                             :attributes => attrs, 
                             :filter => filter & name_filter ) do |entry|
                             ad_group = entry
                             if ad_group
                                group = self.new
                                group.map_group_from_ad(ad_group)
                                ad_groups << group
                             end
                             
                               
        end
         
        ad_groups
        
      end
      
    end
    
  end
  
end