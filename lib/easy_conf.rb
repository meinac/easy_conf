require "easy_conf/version"
require "easy_conf/app_config"
require "easy_conf/configuration"
require "easy_conf/errors/config_not_found_error"
require "easy_conf/errors/unpermitted_config_error"
require "easy_conf/errors/config_file_not_found_error"

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

    # Configures the EasyConf gem for the following keys;
    #
    # config_files    : Required! List of configuration files to be used.
    # inform_with     : Optional. Information method used in case of error.
    #                   Whether sliently puts log or raises exception.
    # white_list_keys : Optional. List of config keys to be used.
    #                   If this configuration is set, config keys
    #                   which are not in this list won't be
    #                   accessible through EasyConf!
    # black_list_keys : Optional! List of config keys to be ignored.
    #                   If this configuration is set, config keys
    #                   which are in this list won't be accessible
    #                   through EasyConf!
    # environment     : Optional. Specifies environment scope. For Rails
    #                   applications, the value is same with Rails.
    #
    # Example:
    #
    #   EasyConf.configure do |config|
    #     config.config_files    = [config.yml]
    #     config.white_list_keys = ['access_key', 'secret_key', ...]
    #     config.black_list_keys = ['black_key', ...]
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
