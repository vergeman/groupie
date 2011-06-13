class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :admin_id
      t.string :title
      t.string :description
      t.datetime :event_date
      t.integer :starting_votes
      
      t.timestamps
    end

    add_index :events, :admin_id
  end

  def self.down
    remove_index :events, :admin_id
    drop_table :events
  end
end
