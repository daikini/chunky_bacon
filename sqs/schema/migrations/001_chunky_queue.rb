# For details on Sequel migrations see 
# http://sequel.rubyforge.org/
# http://code.google.com/p/ruby-sequel/wiki/Migrations

class ChunkyQueueMigration < Sequel::Migration

  def up
    ChunkyQueue.create_table
  end

  def down
    ChunkyQueue.drop_table
  end

end
