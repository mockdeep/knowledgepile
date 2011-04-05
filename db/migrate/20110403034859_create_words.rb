class CreateWords < ActiveRecord::Migration
  def self.up
    create_table :words do |t|
      t.string :title
      t.string :part_of_speech
      t.integer :article_id
      t.integer :gender
      t.integer :rank
      t.references :language

      t.timestamps
    end
  end

  def self.down
    drop_table :words
  end
end
