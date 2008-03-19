class ChunkyMessage < Sequel::Model
  set_schema do
    primary_key :id
    integer :chunky_queue_id
    text :body
    datetime :queued_at
    datetime :received_at

    index :chunky_queue_id
  end
  
  after_initialize do
    self.queued_at = Time.now if queued_at.blank?
  end
end
ChunkyMessage.create_table! unless ChunkyMessage.table_exists?
