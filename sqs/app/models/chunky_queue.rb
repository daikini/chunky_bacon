class ChunkyQueue < Sequel::Model
  set_schema do
    primary_key :id
    varchar :name, :size => 32, :unique => true
    integer :visibility_timeout, :default => 30
  end
  one_to_many :messages, :class => ChunkyMessage, :key => :chunky_queue_id
  
  def to_param
    name
  end
  
  def push(data)
    ChunkyMessage.create :chunky_queue_id => id, :body => data
  end
  
  def receive_messages(number_of_messages = 1, visibility = visibility_timeout)
    received_at = Time.now
    received_messages = messages.filter("received_at IS NULL OR received_at < ?", received_at - visibility).limit(number_of_messages).order_by(:id).all
    received_messages.each { |message| message.set(:received_at => received_at) }
    received_messages
  end
end
ChunkyQueue.create_table unless ChunkyQueue.table_exists?
