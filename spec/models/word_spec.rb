require 'spec_helper'

describe Word do
  before :each do
    @language = Language.new(:title => 'English')
    @language.save
    Language.new(:title => 'Spanish').save
    @word = Word.new(:title => 'House', :language => 'English')
    @word2 = Word.new(:title => 'Casa', :language => 'Spanish')
    @word.save
    @word2.save
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

  it 'should validate uniqueness of rank' do
    # shoulda won't work here since we allow nil
    @word.rank = 1
    @word.save.should be_true # English
    @word2.rank = 1
    @word2.save.should be_true # Spanish
    word3 = Word.new(:title => 'blah', :language => 'English')
    word3.rank = 1
    word3.save.should be_false
    word3.rank = nil
    word3.save.should be_true
    @word.rank = nil
    @word.save.should be_true
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
    Word.find_no_case('houSe').should == [@word]
  end

  it 'should have a scope on ranking' do
    @word.rank = 1
    @word.save
    @word2.rank = 0
    @word2.save
    word3 = Word.new(:title => 'blah', :language => 'English')
    word3.save
    Word.ranked.should == [@word2, @word]
  end

  it 'should have a scope on orphaned words' do
    Word.orphaned.include?(@word).should be_true
    Word.orphaned.include?(@word2).should be_true
    Word.orphaned.length.should == 2
    Word.not_orphaned.length.should == 0

    word = Word.new(:title => 'blah', :language => 'English')
    word.translations << @word2
    word.save
    Word.orphaned.include?(@word2).should be_false
    Word.orphaned.length.should == 1
    Word.not_orphaned.length.should == 2
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
    word3 = Word.new(:title => 'nganda', :language => 'Spanish')
    @word.translations << word3
    Pairing.count.should == 2
    @word.destroy
    Pairing.count.should == 0
  end

  it 'should have a clean output for printing' do
    "#{@word}".should == "House"
  end

  it 'should tell whether it translates to another word' do
    @word.translates_to?("Casa", "Spanish").should be_false
    @word.translations << @word2
    @word.translates_to?("Casa", "Spanish").should be_true
    @word2.translates_to?("House", "English").should be_true
  end
end
