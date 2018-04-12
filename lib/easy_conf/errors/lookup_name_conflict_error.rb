module EasyConf
  class LookupNameConflictError < RuntimeError

    def initialize(name)
      message = "`#{name}` placeholder is conflicting with the internal methods " \
                "of the `EasyConf::Configuration` class. Register lookup with a " \
                "different name to solve this issue!"

      super(message)
    end

  end
end
