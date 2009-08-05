class AddVotingOpenFlag < ActiveRecord::Migration
  def self.up
  	add_column :events, :votingopen, :boolean, :default => false
  end

  def self.down
  	remove_column :events, :votingopen
  end
end
