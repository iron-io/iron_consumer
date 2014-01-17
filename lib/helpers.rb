# hash for user to stuff things to use later.
module IronConsumer
  @@connections = {}

  def self.connections
    return @@connections
  end

  def self.set_message(m)
    @@message = m
  end

  def self.message
    @@message
  end

end
