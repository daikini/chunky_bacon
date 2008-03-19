# For details on Sequel migrations see 
# http://sequel.rubyforge.org/
# http://code.google.com/p/ruby-sequel/wiki/Migrations

class ChunkyMessageMigration < Sequel::Migration

  def up
    ChunkyMessage.create_table
  end

  def down
    ChunkyMessage.drop_table
  end

end
