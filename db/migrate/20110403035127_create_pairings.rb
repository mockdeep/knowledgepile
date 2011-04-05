class CreatePairings < ActiveRecord::Migration
  def self.up
    create_table :pairings do |t|
      t.integer :word_id
      t.integer :translation_id

      t.timestamps
    end
  end

  def self.down
    drop_table :pairings
  end
end
