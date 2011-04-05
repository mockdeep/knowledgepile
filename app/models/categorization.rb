class Categorization < ActiveRecord::Base
  belongs_to :word
  belongs_to :category
  validates_presence_of :word_id
  validates_presence_of :category_id
end
