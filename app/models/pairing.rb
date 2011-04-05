class Pairing < ActiveRecord::Base
  belongs_to :word
  belongs_to :translation, :class_name => 'Word'

  validates_presence_of :word_id
  validates_presence_of :translation_id
end
