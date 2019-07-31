require "yaml"

# Reads configurations from YAML files.
#
# This lookup is registered by default, you can de-register
# it with;
#
#   EasyConf.de_register_lookup(EasyConf::Lookup::Yaml)
#
# The lookup has two configuration keys;
#
#   config_files : The list of files that the lookup will be performed against.
#   scope        : If set, the configuration key will be searched in file under
#                  the scope key. Use case of this config is, setting it as app
#                  env so in one file you can have all the configs for all the
#                  environments but the value this module will return will be
#                  the one for that environment.
#
# Configure as following;
#
# EasyConf.configure do |config|
#   config.yaml.config_files = [...]
#   config.yaml.scope = Rails.env
# end
module EasyConf
  module Lookup
    class Yaml < AbstractLookup

      class << self
        def read(key)
          value = dict[key.to_s]
          !value.nil? && commit(value)
        end

        private
          def dict
            @dict ||= read_config_files
          end

          def read_config_files
            config_files.reduce({}) do |memo, config_file|
              read_config_file(config_file).to_h.each { |k, v| memo[k.to_s] = v }

              memo
            end
          end

          def read_config_file(config_file)
            raise ConfigFileMissing.new(config_file) unless File.exist?(config_file)

            content = YAML.load_file(config_file)
            scope ? content[scope] : content
          end

          def config_files
            EasyConf.configuration.yaml.config_files.to_a
          end

          def scope
            EasyConf.configuration.yaml.scope
          end

      end

    end
  end
end

EasyConf.register_lookup(EasyConf::Lookup::Yaml)
