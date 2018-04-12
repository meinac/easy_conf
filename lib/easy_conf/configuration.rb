require "ostruct"

module EasyConf
  class Configuration # :nodoc
    attr_accessor :decoder
    attr_reader :lookups

    def initialize
      @lookups = []
    end

    def lookups=(lookups)
      @lookups = lookups.to_a
    end

    def register_lookup(klass)
      register_placeholder(klass.placeholder)
      @lookups << klass
    end

    def de_register_lookup(klass)
      @lookups -= [klass]
    end

    private
      def register_placeholder(placeholder)
        check_placeholder_conflict!(placeholder)

        instance_variable_set("@#{placeholder}_conf", OpenStruct.new)

        define_singleton_method(placeholder) do
          instance_variable_get("@#{placeholder}_conf")
        end
      end

      def check_placeholder_conflict!(placeholder)
        raise LookupNameConflictError.new(placeholder) if self.class.instance_methods(:false).include?(placeholder)
      end

  end
end
