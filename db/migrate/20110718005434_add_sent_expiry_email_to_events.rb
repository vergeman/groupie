class AddSentExpiryEmailToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :sent_expiry_email, :boolean
  end

  def self.down
    remove_column :events, :sent_expiry_email
  end
end
