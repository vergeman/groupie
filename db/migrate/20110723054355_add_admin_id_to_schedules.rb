class AddAdminIdToSchedules < ActiveRecord::Migration
  def self.up
    add_column :schedules, :admin_id, :integer
  end

  def self.down
    remove_column :schedules, :admin_id
  end
end
