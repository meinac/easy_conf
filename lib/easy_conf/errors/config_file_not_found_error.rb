module EasyConf
  class ConfigFileNotFoundError < IOError

    def backtrace
      []
    end

  end
end