# Reads configurations from YAML files.
#
# This lookup is registered by default, you can de-register
# it with;
#
#   EasyConf.de_register_lookup(EasyConf::Lookup::Env)
module EasyConf
  module Lookup
    class Env < AbstractLookup

      class << self
        def read(key)
          value = ENV[key.to_s]
          value && commit(value)
        end
      end

    end
  end
end

EasyConf.register_lookup(EasyConf::Lookup::Env)
