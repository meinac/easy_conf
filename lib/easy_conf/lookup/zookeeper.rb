require "zk"

# Reads configurations from Zookeeper.
#
# This lookup is NOT registered by default, you can register
# it with;
#
#   EasyConf.register_lookup(EasyConf::Lookup::Zookeeper)
#
# Beside the Zookeeper configuration which has to be done seperately,
# the lookup has one mandatory configuration key;
#
#   key_prefix : If you are already familiar with Zookeeper, you may know that the values
#                are stored in paths like 'my_app/foo'. Here the key is foo and the
#                value of foo is stored at my_app directory. The prefix has to be set
#                by the user depending on the way how they configured and use Zookeeper.
#                Note that, leading / is a must. If the configuration is set on root path
#                you can set `key_prefix` as empty string.
#
# Configure as following;
#
# EasyConf.configure do |config|
#   config.zookeeper.key_prefix = '/my_app/foo'
#   config.zookeeper.addresses = ['localhost:2181', 'localhost:2182', 'localhost:2183']
# end
#
# Additionally you can set the Vault configurations via ENV like so;
#
#   export ZOOKEEPER_ADDR=localhost:2181,localhost:2182,localhost:2183
module EasyConf
  module Lookup
    class Zookeeper < AbstractLookup

      class << self
        def read(key)
          value = read_zookeeper(key)
          value && commit(value)
        end

        private
          def read_zookeeper(key)
            zookeeper_path = key_path(key)

            client.get(zookeeper_path)[0]
          rescue ZK::Exceptions::NoNode
          end

          def client
            @client ||= ZK.new(zookeeper_address)
          end

          def zookeeper_address
            lookup_config.addresses ? lookup_config.addresses.join(',') : ENV['ZOOKEEPER_ADDR']
          end

          def key_path(key)
            "#{lookup_config.key_prefix}/#{key}"
          end
      end

    end
  end
end
