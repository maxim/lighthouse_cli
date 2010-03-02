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

    def fetch_next_milestone
      @next_milestone ||= fetch_future_milestones.min{|a,b| a.due_on <=> b.due_on}
    end

    def fetch_future_milestones
      @future_milestones ||= fetch_all_milestones.find_all{|m| m.due_on > Time.now}
    end

    def fetch_all_milestones
      @all_milestones ||= @project.milestones.sort{|a,b| b.due_on <=> a.due_on}
    end

    def fetch_milestones_by_title(title)
      fetch_all_milestones.select{|m| m.title =~ /#{title}/i}
    end

    def display_tickets(tickets)
      puts AutoTable.render tickets, :fields => [:number, :title], :max_width => width
    end

    def display_milestones(milestones)
      puts AutoTable.render milestones, :fields => [:title, :tickets_count, :open_tickets_count, :due_on],
                                        :headers => { :due_on => "due",
                                                      :title => "title",
                                                      :tickets_count => "tickets",
                                                      :open_tickets_count => "open"},
                                        :filters => {
                                          :due_on => [:strftime, "%m/%d/%Y"]
                                        },
                                        :max_width => width
    end

    def width
      `stty size`.split.map { |x| x.to_i }.reverse.first
    rescue
      30
    end
  end
end