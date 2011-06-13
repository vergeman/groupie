class AddGroupForeignKeys < ActiveRecord::Migration
  def self.up
    add_column :groups, :user_id, :integer
    add_column :groups, :event_id, :integer
  end

  def self.down
    remove_column :groups, :user_id, :integer
    remove_column :groups, :event_id, :integer
  end
end
