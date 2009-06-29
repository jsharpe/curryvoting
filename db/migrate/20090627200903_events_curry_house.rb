class EventsCurryHouse < ActiveRecord::Migration
  def self.up
  	create_table :curryhouses_events, :id=> false do |t|
		t.integer :curryhouse_id
		t.integer :event_id
	end
	add_index :curryhouses_events, [:curryhouse_id]
	add_index :curryhouses_events, [:event_id]
  end

  def self.down
  	drop_table :curryhouses_events
  end
end
