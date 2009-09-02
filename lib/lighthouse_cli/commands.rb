module LighthouseCLI
  module Commands
    def add(title, tags = [])
      create_ticket(title, tags)
      puts "Ticket added."
    end

    def list(which = "next")
      tickets = case which
      when 'next'
        fetch_tickets("responsible:me milestone:#{next_milestone.title} state:open sort:priority")
      end

      display_tickets tickets
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
  end
end