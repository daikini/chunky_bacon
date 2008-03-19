require 'sequel'

module RightAws
  class Sqs
    def initialize(access_id, access_key, options = {})
      ChunkyQueue.connect
    end
    
    def queue(name, create = true)
      ChunkyQueue.find_by_name(name) || (create && ChunkyQueue.create(name))
    end
  end
end

class ChunkyQueue
  @db = nil
  attr_accessor :id, :name
  
  def self.db
    @db
  end
  
  def self.db=(db)
    @db = db
  end
  
  def self.connect
    self.db = Sequel.open "mysql://root:@localhost:3601/chunky_bacon"
    
    db.create_table :chunky_queues do
      primary_key :id
      varchar :name, :size => 32, :unique => true
      integer :visibility_timeout, :default => 30
    end unless db.table_exists?(:chunky_queues)
    
    db.create_table :chunky_messages do
      primary_key :id
      integer :chunky_queue_id
      text :body
      datetime :queued_at
      datetime :received_at

      index :chunky_queue_id
    end unless db.table_exists?(:chunky_messages)
  end
  
  def self.create(name)
    id = db[:chunky_queues].insert(:name => name)
    queue = new(id, name)
  end
  
  def self.find_by_name(name)
    if chunky_queue = db[:chunky_queues].filter(:name => name).first
      new(chunky_queue[:id], name)
    end
  end
  
  def initialize(id, name)
    @id = id
    @name = name
  end
  
  def push(data)
    db[:chunky_messages].insert(:chunky_queue_id => id, :body => data, :queued_at => Time.now)
  end
  
  def receive
    receive_messages(1).first
  end
  
  def receive_messages(number_of_messages = 1)
    received_at = Time.now
    received_messages = db[:chunky_messages].filter("chunky_queue_id = ? AND received_at IS NULL OR received_at < ?", id, (received_at - 30)).limit(number_of_messages).order_by(:id).all
    received_messages.collect do |message|
      # Update the received_at
      db[:chunky_messages].filter(:id => message[:id]).update(:received_at => received_at) 
      
      # Create the chunky message
      ChunkyMessage.new(self, message[:id], message[:body])
    end
  end
  
  def size
    db[:chunky_messages].filter(:chunky_queue_id => id).count
  end
  
  def db
    self.class.db
  end
end

class ChunkyMessage
  attr_accessor :id, :body
  
  def initialize(chunky_queue, id, body)
    @chunky_queue = chunky_queue
    @id = id
    @body = body
  end
  
  def delete
    chunky_queue.db[:chunky_messages].filter(:id => id).delete
  end
  
  private
    def chunky_queue
      @chunky_queue
    end
end
