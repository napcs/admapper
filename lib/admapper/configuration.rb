module ADMapper
  # Holds configuration options.
  class Configuration

    @connection_info = nil
    class << self; attr_accessor :connection_info; end

  end
  
  # Configuration exception
  class ConfigurationMissingError < StandardError
  end
end