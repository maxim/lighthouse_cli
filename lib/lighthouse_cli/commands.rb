module LighthouseCLI
  module Commands
    def add(title, tags = [])
      create_ticket(title, tags)
      puts "Ticket added."
    end

    def list(which = "next")
      case which
      when 'next'
        milestone = fetch_next_milestone
        if (milestone)
          puts "Milestone: #{milestone.title}"
          tickets = fetch_tickets("responsible:me milestone:#{fetch_next_milestone.title} state:open sort:priority")
          display_tickets tickets
        else
          tickets = fetch_tickets
          display_tickets tickets
        end
      else
        milestones = fetch_milestones_by_title(which)
        milestones.each do |ms|
          puts "Milestone: #{ms.title}"
          tickets = fetch_tickets("responsible:me milestone:#{ms.title} state:open sort:priority")
          display_tickets tickets
          puts "\n"
          sleep 1
        end
      end
    end

    def resolve(id)
      t = fetch_ticket(id)
      t.state = 'resolved'
      if t.save
        puts "Resolved: \"#{t.title}\""
      else
        puts "Failed trying to resolve ticket."
      end
    end

    def open(id)
      t = fetch_ticket(id)
      t.state = 'new'
      if t.save
        puts "Opened: \"#{t.title}\""
      else
        puts "Failed trying to open ticket."
      end
    end

    def show(id)
      ticket = fetch_ticket(id)
      puts "  Ticket ##{id} (#{ticket.state})"
      puts "  #{ticket.title}"
      puts "  #{ticket.body}" unless ticket.body.blank?
      puts "  #{ticket.tags.join(', ')}" unless ticket.tags.blank?
    end

    def ms(which = "future")
      milestones = case which
      when 'all'
        fetch_all_milestones
      when 'future'
        fetch_future_milestones
      end

      display_milestones milestones
    end

    def help
      puts <<-TEXT
  Available commands:
  help
    Show this text.

  list [milestone_name]
    List all assigned tickets from next upcoming milestone (by default). Otherwise, list all tickets in all milestones matching milestone name.

  ms [all]
    List future milestones (by default). List all milestones when option "all" provided.

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
  end
end