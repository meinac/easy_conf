module EasyConf
  class AppConfig # :nodoc

    MESSAGES = {
      unpermitted_key:  'Found unpermitted key'.freeze,
      file_not_found:   'Configuration file not found'.freeze,
      config_not_found: 'Configuration not found'.freeze,
    }

    EXCEPTIONS = {
      unpermitted_key:  'UnpermittedConfigError'.freeze,
      file_not_found:   'ConfigFileNotFoundError'.freeze,
      config_not_found: 'ConfigNotFoundError'.freeze,
    }

    def initialize
      @table = __read_config
    end

    def method_missing(meth, *args, &block)
      return __notify(:unpermitted_key, meth) if __list_check(meth)

      __read_from_table(meth) || __read_from_env(meth) || __notify(:config_not_found, meth)
    end

    def __keys
      @table.keys
    end

    def __to_hash
      @table.dup
    end

    private
      def __configuration
        EasyConf.configuration
      end

      def __read_config
        env = __configuration.environment.to_s

        __configuration.config_files.inject({}) do |conf, config_file|
          tmp = if File.exists?(config_file)
            yaml_data = YAML.load_file(config_file)
            env.blank? ? yaml_data : yaml_data.fetch(env, {})
          else
            __notify(:file_not_found, config_file) && {}
          end
          conf.merge(tmp)
        end
      end

      def __read_from_table(key)
        if val = @table[key.to_s]
          define_singleton_method(key) { val }
          send(key)
        end
      end

      def __read_from_env(key)
        if val = ENV[key.to_s]
          define_singleton_method(key) { val }
          send(key)
        end
      end

      def __list_check(key)
        (__configuration.black_list_keys.length > 0 && __configuration.black_list_keys.include?(key)) ||
          (__configuration.black_list_keys.length == 0 &&
            (__configuration.white_list_keys.length > 0 && !__configuration.white_list_keys.include?(key)))
      end

      def __notify(event, obj)
        message = "#{MESSAGES[event]}: `#{obj}`"

        if __configuration.inform_with == :exception
          exception_class = "EasyConf::#{EXCEPTIONS[event]}"
          raise exception_class.constantize.new(message)
        else
          puts message
        end
      end
  end
end