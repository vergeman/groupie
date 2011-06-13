class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :user_id
      t.string :title
      t.string :description
      t.datetime :event_date

      t.timestamps
    end

    add_index :events, :user_id
  end

  def self.down
    drop_table :events
  end
end
