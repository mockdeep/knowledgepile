require 'spec_helper'

describe Categorization do
  it 'should associate' do
    should belong_to :word
    should belong_to :category
  end

  it 'should validate' do
    should validate_presence_of :word_id
    should validate_presence_of :category_id
  end
end
