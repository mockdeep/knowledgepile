class Word < ActiveRecord::Base

  cattr_reader :per_page
  @@per_page = 100

  has_many :pairings, :dependent => :destroy
  has_many :translations, :through => :pairings, :class_name => 'Word'
  has_many :categorizations
  has_many :categories, :through => :categorizations
  belongs_to :formal_language, :class_name => 'Language', :foreign_key => 'language_id'

  validates_presence_of :title
  validates_presence_of :formal_language
  validates_uniqueness_of :rank, :scope => :language_id, :allow_nil => true

  scope :language, lambda { |lang| joins(:formal_language).where('languages.title = ?', lang) }
  scope :find_all_no_case, lambda { |word| where("lower(words.title) = ?", word.downcase) }
  scope :ranked, where('rank NOT NULL').order('rank ASC')
  scope :orphaned, where('NOT EXISTS (SELECT * FROM pairings as pairings WHERE pairings.word_id = words.id)')
  scope :not_orphaned, where('EXISTS (SELECT * FROM pairings as pairings WHERE pairings.word_id = words.id)')

  def language=(lang)
    new_language = Language.find_by_title(lang)
    if new_language
      self.formal_language = new_language
    else
      raise "No such language"
    end
  end

  def language
    formal_language.title
  end

  def translate_to(lang)
    translations.collect { |word| word if word.language == lang }.compact
  end

  def to_s
    title
  end
end
