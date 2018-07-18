require "vault"

# Reads configurations from Vault.
#
# This lookup is NOT registered by default, you can register
# it with;
#
#   EasyConf.register_lookup(EasyConf::Lookup::EVault)
#
# Beside the Vault configuration which has to be done seperately,
# the lookup has one mandatory configuration key;
#
#   key_prefix : If you are already familiar with Vault, you may know that the values
#                are stored in paths like 'secret/foo'. Here the key is foo and the
#                value of foo is stored at secret engine. The prefix has to be set
#                by the user depending on the way how they configured and use Vault.
#
# Configure as following;
#
# EasyConf.configure do |config|
#   config.vault.key_prefix = 'secret/foo/bar'
# end
#
# Additionally you can set the Vault configurations via ENV like so;
#
#   export VAULT_ADDR=http://127.0.0.1:8200
#   export VAULT_TOKEN=token
#   export VAULT_SSL_VERIFY=false
module EasyConf
  module Lookup
    class EVault < AbstractLookup
      self.placeholder = :vault

      class << self
        def read(key)
          value = read_vault(key)
          value && commit(value)
        end

        private
          def read_vault(key)
            vault_path = key_path(key)

            secret = Vault.with_retries(Vault::HTTPError) do
              Vault.logical.read(vault_path)
            end

            secret && secret.data && secret.data[:value]
          end

          def key_path(key)
            "#{lookup_config.key_prefix}/#{key}"
          end

      end

    end
  end
end
