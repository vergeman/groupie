class CreateParticipants < ActiveRecord::Migration
  def self.up
    create_table :participants do |t|
      t.integer :user_id
      t.integer :event_id
      t.integer :votes_remaining

      t.timestamps
    end

    add_index :participants, :user_id
    add_index :participants, :event_id

  end

  def self.down
    remove_index :participants, :user_id
    remove_index :participants, :event_id

    drop_table :participants

  end
end
