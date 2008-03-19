# For details on Sequel migrations see 
# http://sequel.rubyforge.org/
# http://code.google.com/p/ruby-sequel/wiki/Migrations

class InstanceMigration < Sequel::Migration

  def up
    create_table :instances do
      primary_key :id
    end
  end

  def down
    execute "DROP TABLE instances"
  end

end
