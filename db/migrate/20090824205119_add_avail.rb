class AddAvail < ActiveRecord::Migration
  def self.up
	add_column :votes, :avail, :string
  end

  def self.down
	remove_column :votes, :avail
  end
end
