class Pairing < ActiveRecord::Base
  belongs_to :word
  belongs_to :translation, :class_name => 'Word'

  validates_presence_of :word_id
  validates_presence_of :translation_id
  validates_uniqueness_of :translation_id, :scope => [ :word_id ]
  validates_uniqueness_of :word_id, :scope => [ :translation_id ]

  after_create :create_mirror
  after_destroy :destroy_mirror

private

  def create_mirror
    mirrors = Pairing.where(:word_id => translation.id, :translation_id => word.id)
    if mirrors.empty?
      Pairing.create(:word_id => translation.id, :translation_id => word.id)
    end
  end

  def destroy_mirror
    if translation && word
      mirrors = Pairing.where(:word_id => translation.id, :translation_id => word.id)
      mirrors.each do |mirror|
        mirror.destroy
      end
    end
  end
end
