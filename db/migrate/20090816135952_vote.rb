class Vote < ActiveRecord::Migration
  def self.up
  	add_column :votes, :userid, :integer
  end

  def self.down
  	remove_column :votes, :userid
  end
end
