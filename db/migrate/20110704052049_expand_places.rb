class ExpandPlaces < ActiveRecord::Migration
  def self.up
    #name & descprition exist prior
    add_column :places, :cid, :string
    add_column :places, :address, :string
    add_column :places, :neighborhood, :string
    add_column :places, :rating, :string
    add_column :places, :price, :string
    add_column :places, :reference, :string
    add_column :places, :url, :string
    add_column :places, :comments, :text
    add_column :places, :external_links, :text #expect serialized hash
    add_column :places, :image_links, :text #expect serialized hash

    add_index :places, :cid
  end

  def self.down

    remove_index :places, :cid

    remove_column :places, :cid, :string
    remove_column :places, :address, :string
    remove_column :places, :neighborhood, :string
    remove_column :places, :rating, :string
    remove_column :places, :price, :string
    remove_column :places, :reference, :string
    remove_column :places, :url, :string
    remove_column :places, :comments, :text
    remove_column :places, :external_links, :text
    remove_column :places, :image_links, :text

  end
end
