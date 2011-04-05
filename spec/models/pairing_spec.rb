require 'spec_helper'

describe Pairing do
  it 'should associate' do
    should belong_to :word
    should belong_to :translation
  end

  it 'should validate' do
    should validate_presence_of :word_id
    should validate_presence_of :translation_id
  end
end
