class CurryhousesVotes < ActiveRecord::Migration
  def self.up
  	create_table :curryhouses_votes, :force => true, :id=>false do |t|
		t.integer :curryhouse_id
		t.integer :vote_id
		t.timestamps
	end
	add_index :curryhouses_votes, [:curryhouse_id]
	add_index :curryhouses_votes, [:vote_id]
  end

  def self.down
  	drop_table :curryhouse_votes
  end
end
