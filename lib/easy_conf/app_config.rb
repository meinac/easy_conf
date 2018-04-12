module EasyConf
  class AppConfig # :nodoc

    def initialize
      @dict = {}
    end

    def method_missing(meth, *args, &block)
      define_singleton_method(meth) do
        @dict[meth]
      end

      @dict[meth] = LookupVisitor.visit(meth)
    end

    def __keys
      @dict.keys
    end

    def __to_hash
      @dict.dup
    end

  end
end
