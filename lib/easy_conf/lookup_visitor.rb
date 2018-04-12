module EasyConf
  class LookupVisitor

    def self.visit(key)
      catch(:config_found) do
        EasyConf.configuration.lookups.each { |lookup| lookup.read(key) }
        nil
      end
    end

  end
end
