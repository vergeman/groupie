class AddEventKeyToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :event_key, :string
  end

  def self.down
    remove_column :events, :event_key
  end
end
