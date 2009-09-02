module LighthouseCLI
  module Helpers
    private
    include Hirb::Helpers
    
    def create_ticket(title, tags)
      ticket = Lighthouse::Ticket.new(:project_id => @project.id)
      ticket.title = title
      ticket.tags = tags.split
      ticket.save
    end
    
    def fetch_ticket(id)
      Lighthouse::Ticket.find(id, q)
    end
    
    def fetch_tickets(str = '')
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
    rescue
      30
    end
  end
end