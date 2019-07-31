module EasyConf
  class ConfigFileMissing < RuntimeError

    def initialize(file_name)
      super("`#{file_name}` file does not exist!")
    end

  end
end
