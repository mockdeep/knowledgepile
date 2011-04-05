class Category < ActiveRecord::Base
  has_many :categorizations
  has_many :words, :through => :categorizations

  validates_presence_of :title
  validates_uniqueness_of :title
end
