require File.expand_path(File.join(File.dirname(__FILE__), '..', 'vendor', 'lighthouse-api', 'lib', 'lighthouse-api'))

module LighthouseCLI
  DEFAULT_CONFIG_PATH = "Lhcfile"
  
  def bootstrap!
    Authenticator.authenticate!
    ::Lighthouse.account = Config.account
  end
  
  def project
    project_name = Config.project
    
    @project ||= if project_name
      ::Lighthouse::Project.find(:all).find{|p| p.name == Config.project}
    else
      nil
    end
    
    @project || (raise RuntimeError.new("Project not found or wasn't configured."))
  end
  
  module_function :bootstrap!, :project
  

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
  
  class Parser
    class << self
      include Hirb::Helpers
      
      def go!
        (help; return) if ARGV.blank?
      
        LighthouseCLI.bootstrap!
        @project = LighthouseCLI.project
        self.send(ARGV.shift.to_sym, *ARGV)
      end
      
      def add(title, tags = [])
        new_ticket(title, tags)
        puts "Ticket added."
      end
      
      def list(which = "next")
        list = case which
        when 'next'
          tickets("responsible:me milestone:#{next_milestone.title} state:open sort:priority")
        end
        
        display_tickets list
      end
      
      def resolve(id)
        t = ticket(id)
        t.state = 'resolved'
        t.save
        puts "Resolved: \"#{t.title}\""
      end
      
      def open(id)
        t = ticket(id)
        t.state = 'new'
        t.save
        puts "Opened: \"#{t.title}\""
      end
      
      def show(id)
        ticket = ticket(id)
        puts "  Ticket ##{id} (#{ticket.state})"
        puts "  "+ticket.title
        puts "  "+ticket.body unless ticket.body.blank?
        puts "  "+ticket.tags.join(', ') unless ticket.tags.blank? 
      end
    
      def help
        puts <<-TEXT
  Available commands:
  help
    Show this text.
  
  list
    List all assigned tickets from upcoming milestone.
    
  show 50
    Show details for ticket with given id.
  
  add "Ticket name" "tag1 tag2"
    Add ticket for yourself into current milestone with (optional) tags and without any body.
  
  resolve 50
    Mark ticket 50 resolved.
  
  open 50
    Mark ticket 50 new.
        TEXT
      end
      
      private
      def new_ticket(title, tags)
        ticket = Lighthouse::Ticket.new(:project_id => @project.id)
        ticket.title = title
        ticket.tags = tags.split
        ticket.save
      end
      
      def ticket(id)
        Lighthouse::Ticket.find(id, q)
      end
      
      def tickets(str = '')
        query = q(str)
        Lighthouse::Ticket.find(:all, query)
      end
      
      def q(str = '')
        {:params => {:q => str, :project_id => @project.id}}
      end
      
      def next_milestone
        @next_milestone ||= @project.milestones.find_all{|m| m.due_on > Time.now}.min{|a,b| a.due_on <=> b.due_on}
      end
      
      def display_tickets(tickets)
        puts AutoTable.render tickets, :fields => [:number, :title], :max_width => width
      end
      
      def width
        `stty size`.split.map { |x| x.to_i }.reverse.second
      end
    end
  end
end