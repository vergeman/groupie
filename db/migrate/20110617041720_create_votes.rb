class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :participant_id
      t.integer :place_id
      t.integer :vote

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
