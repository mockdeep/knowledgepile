class CreateCategorizations < ActiveRecord::Migration
  def self.up
    create_table :categorizations do |t|
      t.references :category
      t.references :word

      t.timestamps
    end
  end

  def self.down
    drop_table :categorizations
  end
end
