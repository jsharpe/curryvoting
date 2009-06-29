class CreateCurryhouses < ActiveRecord::Migration
  def self.up
    create_table :curryhouses do |t|
      t.string :title
      t.text :description
      t.string :postcode
      t.string :phone_number
      t.string :website

      t.timestamps
    end
  end

  def self.down
    drop_table :curryhouses
  end
end
