module ADMapper
  class Connection
      @@ad_connection = nil
      @@ad_treebase = nil
      @@ad_user_filter = nil
      
      def self.treebase
        @@ad_treebase
      end
      
      # class method to return the current connection
      def self.current_connection
        self.ad_connect_if_not_connected
        @@ad_connection
      end
      
      def self.current_connection=(conn)
        @@ad_connection = conn
      end
      
     # config_options = {:username => "homer",
      #                   :password => "1234",
      #                   :domain => "springfieldnuclear.com",
      #                   :host => "ad.springfieldnuclear.com",
      #                   :ssl => true,
      #                   :port => 636}
      #
      # if ad_connect!(config_options)
      #    ....
      # else
      #   ...
      # end
      def self.ad_connect!(config = nil)
       config ||= ADMapper::Configuration.connection_info

       raise ADMapper::ConfigurationMissingError if config.nil?
       username = config[:username]
       password = config[:password]
       domain = config[:domain]
       host = config[:host]
       port = config[:port]
       dc1 = domain.split(".").first
       dc2 = domain.split(".").last
       ssl = config[:ssl] ? true : false
       self.current_connection = initialize_ldap_con(username + "@#{domain}", password, host, port, ssl) 
       @@ad_treebase = "DC=#{dc1},DC=#{dc2}" 
       @@ad_user_filter = Net::LDAP::Filter.eq( "sAMAccountName", username ) 
       self.current_connection.bind
      end
       
      # initializes the connection to the ldap server. Does not bind.
      def self.initialize_ldap_con(user_name, password, host, port, ssl)
         ldap = Net::LDAP.new
         ldap.host = host
         ldap.port = port #required for SSL connections, 389 is the default plain text port
         if ssl 
           ldap.encryption :simple_tls #also required to tell Net:LDAP that we want SSL
         end
         ldap.auth "#{user_name}","#{password}"
         ldap #explicitly return the ldap connection object
      end
     
       # connects if not connected already
       def self.ad_connect_if_not_connected
         self.ad_connect! if @@ad_connection.nil?
       end
    
  end
end