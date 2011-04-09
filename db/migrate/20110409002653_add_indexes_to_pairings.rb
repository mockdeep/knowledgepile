class AddIndexesToPairings < ActiveRecord::Migration
  def self.up
    add_index :pairings, :word_id
    add_index :pairings, :translation_id
  end

  def self.down
    remove_index :pairings, :word_id
    remove_index :pairings, :translation_id
  end
end
