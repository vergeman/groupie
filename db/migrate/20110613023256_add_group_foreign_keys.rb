class AddGroupForeignKeys < ActiveRecord::Migration
  def self.up
    add_column :groups, :user_id, :integer
    add_column :groups, :event_id, :integer

    add_index :groups, :user_id
    add_index :groups, :event_id
    add_index :groups, [:user_id, :event_id], :unique => true
  end

  def self.down
    remove_column :groups, :user_id, :integer
    remove_column :groups, :event_id, :integer
  end


end
