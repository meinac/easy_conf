require "easy_conf/version"
require "easy_conf/app_config"
require "easy_conf/lookup_visitor"
require "easy_conf/configuration"
require "easy_conf/errors/config_file_missing"
require "easy_conf/errors/interface_error"
require "easy_conf/errors/lookup_name_conflict_error"
require "easy_conf/errors/config_not_found_error"
require "easy_conf/lookup/abstract_lookup"

module EasyConf

  class << self
    # Returns all configurations of your applications.
    #
    # Example:
    #
    #   EasyConf.app_config # => <EasyConf::AppConfig>
    #
    # You can access configurations of your application by
    # method call with configuration name.
    #
    # Example:
    #
    #   EasyConf.app_config.access_key # => "some_key"
    def app_config
      @config ||= AppConfig.new
    end

    # Read Application configuration by sending key as argument.
    #
    # Example:
    #
    #   EasyConf.read(:access_key) # => "some_key"
    def read(key)
      app_config.send(key.to_s)
    end
    alias_method :get, :read

    # Read Application config keys
    #
    # Example:
    #
    #   EasyConf.keys # => [:foo, :bar, ...]
    def keys
      app_config.__keys
    end

    # Get application configs as Hash
    #
    # Example:
    #
    #   EasyConf.to_hash # => { foo: 'bar', ... }
    def to_hash
      app_config.__to_hash
    end

    # Registers a new lookup class to the lookup list.
    #
    # Example:
    #
    #   EasyConf.register_lookup(EasyConf::Lookup::Env)
    def register_lookup(klass)
      configuration.register_lookup(klass)
    end

    # De-registers the lookup class from the lookup list.
    #
    # Example:
    #
    #   EasyConf.de_register_lookup(EasyConf::Lookup::Env)
    def de_register_lookup(klass)
      configuration.de_register_lookup(klass)
    end

    # Configures the EasyConf gem for the following keys;
    #
    # lookups : Optional. An array of lookup classes. By default, EasyConf uses
    #           ENV and YAML lookups.
    # decoder : Optional. If you are encoding your config values before saving,
    #           you can let EasyConf decode them automatically by setting this
    #           with a `Proc`. This is usefull if you don't want to handle type
    #           casting in your code.
    #
    # Example:
    #
    #   EasyConf.configure do |config|
    #     config.lookups = [EasyConf::Lookup::Env, EasyConf::Lookup::Yaml]
    #     config.decoder = Proc.new { |value| YAML.load(value) }
    #   end
    def configure
      yield(configuration)
      app_config # initialize config
    end

    def configuration # :nodoc
      @configuration ||= Configuration.new
    end
  end

end

require "easy_conf/lookup/env"
require "easy_conf/lookup/yaml"
require "easy_conf/lookup/e_vault"
require "easy_conf/lookup/zookeeper"
