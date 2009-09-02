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
      end
    end
  end
end