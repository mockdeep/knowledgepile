class Language < ActiveRecord::Base
  has_many :words

  validates_presence_of :title
  validates_uniqueness_of :title

  def to_s
    title
  end
end
