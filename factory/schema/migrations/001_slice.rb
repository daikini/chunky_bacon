# For details on Sequel migrations see 
# http://sequel.rubyforge.org/
# http://code.google.com/p/ruby-sequel/wiki/Migrations

class SliceMigration < Sequel::Migration

  def up
    Slice.create_table
  end

  def down
    Slice.drop_table
  end

end
