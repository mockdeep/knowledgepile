class Word < ActiveRecord::Base
  has_many :pairings, :dependent => :destroy
  has_many :translations, :through => :pairings, :class_name => 'Word'
  has_many :categorizations
  has_many :categories, :through => :categorizations
  belongs_to :formal_language, :class_name => 'Language', :foreign_key => 'language_id'

  validates_presence_of :title
  validates_presence_of :formal_language

  scope :language, lambda { |lang| joins(:formal_language).where('languages.title = ?', lang) }
  scope :find_all_no_case, lambda { |word| where("lower(words.title) = ?", word.downcase) }

  def language=(lang)
    language = Language.find_by_title(lang)
    if language
      self.formal_language = language
    else
      raise "No such language"
    end
  end

  def language
    self.formal_language.title
  end

  def translate_to(lang)
    self.translations.collect { |word| word if word.language == lang }.compact
  end
end
