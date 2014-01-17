# hard coding the stuff here that would normally be generate from initial dependency and connections setup.

require 'iron_mq'

require_relative 'helpers'

module IronConsumer

  def self.run(queue_name)
    qname = queue_name

    # User can have whatever he wants in the usersetup part.
    # We can put the helpers stuff in a gem that user can optionally use or something.

    begin
      load "usersetup.rb"
    rescue LoadError => ex
      p ex
      puts ex.message
      puts "You need a file called usersetup.rb."
      exit false
    end

    # mongo1 name is defined by user
    # Other connections would be made here

    # Iron stuff is setup too:
    mq = IronMQ::Client.new()

    # qname defined by user too
    queue = mq.queue(qname)

    # This worker kicks off whenever a message gets on a queue (only once, needs alerts)
    tries = 0
    max_tries = 3
    sleep_time = 3
    while true
      msg = queue.get
      if msg == nil
        # sleep for a short time to see if we can get another one
        tries += 1
        if tries >= max_tries
          break
        end
        sleep sleep_time
        next
      end
      IronConsumer.set_message(msg)
      begin

        # USER CODE STUFFED IN HERE
        begin
          load "usercode.rb"
        rescue LoadError => ex
          p ex
          puts "You need a file called usercode.rb."
          exit false
        end
        # USER CODE END

        # If finished ok, delete message
        msg.delete

      rescue Exception => ex
        puts "Error in user code #{ex} -- #{ex.message}"
      end
    end
  end
end
