module LighthouseCLI
  class Authenticator
    class << self
      def authenticate!
        auth_data = Config.token ? Config.token : [Config.username, Config.password]
        auth_data.flatten!
      
        if auth_data.size == 1
          authenticate_by_token(*auth_data)
        else
          authenticate_by_credentials(*auth_data)
        end
      end

      private
      def authenticate_by_token(token)
        Lighthouse.token = token
      end

      def authenticate_by_credentials(user, pass)
        Lighthouse.authenticate(user, pass)
      end
    end
  end
end