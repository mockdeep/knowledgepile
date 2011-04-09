class AddIndexesToWords < ActiveRecord::Migration
  def self.up
    add_index :words, :title
    add_index :words, :language_id
    add_index :words, :rank
  end

  def self.down
    remove_index :words, :title
    remove_index :words, :language_id
    remove_index :words, :rank
  end
end
