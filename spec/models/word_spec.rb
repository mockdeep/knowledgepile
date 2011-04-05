require 'spec_helper'

describe Word do
  it 'should associate' do
    should have_many :pairings
    should have_many(:translations).through :pairings
    should have_many :categorizations
    should have_many(:categories).through :categorizations

    should belong_to :language
  end

  it 'should validate' do
    should validate_presence_of 'language'
    should validate_presence_of 'title'
  end
end
