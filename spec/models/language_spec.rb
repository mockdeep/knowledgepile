require 'spec_helper'

describe Language do
  before :each do
    @language = Language.new(:title => 'blah')
    @language.save
  end

  it 'should associate' do
    should have_many :words
  end

  it 'should validate' do
    should validate_presence_of :title
    should validate_uniqueness_of :title
  end
end
