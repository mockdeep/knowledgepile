require 'spec_helper'

describe Category do
  before :each do
    @category = Category.new(:title => 'blah')
    @category.save
  end

  it 'should associate' do
    should have_many :categorizations
    should have_many(:words).through :categorizations
  end

  it 'should validate' do
    should validate_presence_of :title
    should validate_uniqueness_of :title
  end
end
