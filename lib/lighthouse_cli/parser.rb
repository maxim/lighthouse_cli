module LighthouseCLI
  class Parser
    class << self
      include Helpers
      include Commands
      
      def parse_argv!
        (help; return) if ARGV.blank?
      
        LighthouseCLI.bootstrap!
        @project = LighthouseCLI.project
        
        if self.respond_to?(meth = ARGV.shift.to_sym) && meth != :parse_argv!
          self.send(meth, *ARGV)
        else
          puts "Unknown command \"#{meth}\"."
        end
      rescue ActiveResource::TimeoutError, ActiveResource::ServerError
        puts "There seems to be a problem with lighthouse server. Try again in a few."
      end
    end
  end
end