class Word < ActiveRecord::Base
  has_many :pairings
  has_many :translations, :through => :pairings, :class_name => 'Word'
  has_many :categorizations
  has_many :categories, :through => :categorizations
  belongs_to :language

  validates_presence_of :title
  validates_presence_of :language
end
