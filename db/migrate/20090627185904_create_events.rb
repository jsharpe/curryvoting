class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.date :startdate
      t.date :enddate

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
