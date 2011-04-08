require 'spec_helper'

describe Word do
  before :each do
    @language = Language.new(:title => 'English')
    @language.save
    Language.new(:title => 'Spanish').save
    @word = Word.new(:title => 'House', :language => 'English')
    @word2 = Word.new(:title => 'Casa', :language => 'Spanish')
    @word.save
  end

  it 'should associate' do
    should have_many :pairings
    should have_many(:translations).through :pairings
    should have_many :categorizations
    should have_many(:categories).through :categorizations

    should belong_to :formal_language
  end

  it 'should validate' do
    should validate_presence_of :formal_language
    should validate_presence_of :title
  end

  it 'should associate with a language object' do
    @word.language.should == 'English'

    word2 = Word.new(:title => 'cheetah', :language => 'English')
    word2.language.should == 'English'
  end

  it 'should add translations both ways' do
  end

  it 'should only allow languages in Language table' do
    lambda { Word.new(:title => 'tiger', :language => 'cheese') }.should raise_error("No such language")

    word2 = Word.new(:title => 'lion', :language => 'English')
    word2.should be_valid
    word2.save.should be_true
  end

  it 'should have a scope on language' do
    Word.language('English').should == [@word]
  end

  it 'should have a scope for case insensitive search' do
    Word.find_all_no_case('houSe').should == [@word]
  end

  it 'should translate to another language' do
    @word.translations << @word2
    Language.new(:title => 'French').save
    @word.translations << Word.new(:title => 'sacre', :language => 'French')
    @word.translate_to('Spanish').should == [@word2]
  end

  it 'should delete pairings when it is destroyed' do
    @word.translations << @word2
    Pairing.count.should == 2
    @word2.destroy
    Pairing.count.should == 0
  end
end
