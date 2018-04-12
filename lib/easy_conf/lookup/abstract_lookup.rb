require "ostruct"

module EasyConf
  module Lookup
    class AbstractLookup

      class << self
        attr_writer :placeholder

        def read(key)
          raise_interface_error!
        end

        def placeholder
          @placeholder ||= self.to_s.split('::').last.downcase
        end

        private
          def raise_interface_error!
            method_name   = caller_locations(1, 1)[0].label
            error_message = "`#{method_name}` method should be implemented in `#{self.name}` class!"

            raise EasyConf::InterfaceError.new(error_message)
          end

          def commit(raw_value)
            throw(
              :config_found,
              apply_decoding(raw_value) || apply_default_decoding(raw_value) || raw_value
            )
          end

          def apply_decoding(value)
            if lookup_config && lookup_config.decoder
              lookup_config.decoder.call(value)
            end
          end

          def apply_default_decoding(value)
            EasyConf.configuration.decoder.call(value) if EasyConf.configuration.decoder
          end

          def lookup_config
            EasyConf.configuration.send(placeholder)
          end

      end

    end
  end
end
