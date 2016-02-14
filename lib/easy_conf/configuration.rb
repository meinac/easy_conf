module EasyConf
  class Configuration # :nodoc
    attr_accessor :config_files, :inform_with, :white_list_keys, :black_list_keys, :environment

    def initialize
      @config_files    = []
      @inform_with     = :log
      @white_list_keys = []
      @black_list_keys = []
    end

    def white_list_keys=(keys)
      @white_list_keys = keys.map(&:to_sym)
    end

    def black_list_keys=(keys)
      @black_list_keys = keys.map(&:to_sym)
    end

    def environment
      @environment ||= defined?(Rails) ? Rails.env : nil
    end
  end
end