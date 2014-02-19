# hard coding the stuff here that would normally be generate from initial dependency and connections setup.

require 'iron_mq'

require_relative 'helpers'

module IronConsumer

  def self.run(config)
    qname = config['workqueue']

    # User can have whatever he wants in the usersetup part.
    # We can put the helpers stuff in a gem that user can optionally use or something.

    setupfile = config['setup'] || "usersetup.rb"
    begin
      load setupfile
    rescue LoadError => ex
      p ex
      puts ex.message
      puts "You need a file called #{setupfile}"
      exit false
    end

    codefile = config['code'] || "usercode.rb"

    # mongo1 name is defined by user
    # Other connections would be made here

    # Iron stuff is setup too:
    mq = IronMQ::Client.new(config['iron'])

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
          puts "No more messages to process, shutting down."
          break
        end
        sleep sleep_time
        next
      end
      IronConsumer.set_message(msg)
      begin

        # USER CODE STUFFED IN HERE
        begin
          load codefile
        rescue LoadError => ex
          p ex
          puts "You need a file called #{codefile}."
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
