module LighthouseCLI
  class Config
    class << self
      def method_missing(meth, *args, &blk)
        load_config!
        @config[meth]
      end
      
      private
      def load_config!(config_path = DEFAULT_CONFIG_PATH)
        @config ||= YAML.load_file(config_path).symbolize_keys
      rescue
        raise RuntimeError.new("Error: You must put either lighthouse token or space-separated username and password in your Lhcfile. Don't forget to ignore it in git.")
      end
    end
  end
end