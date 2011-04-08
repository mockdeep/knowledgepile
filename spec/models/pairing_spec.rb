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

  before :each do
    Language.new(:title => 'English').save
    @word = Word.new(:title => 'house', :language => 'English')
    @word.save
    @word2 = Word.new(:title => 'beer', :language => 'English')
    @word2.save
  end

  it 'should mirror pairings' do
    @word.translations.count.should == 0
    @word2.translations.count.should == 0
    Pairing.count.should == 0

    @word.translations << @word2
    @word.translations.should == [@word2]
    @word2.translations.should == [@word]
    Pairing.count.should == 2
  end

  it 'should not allow duplicate pairings' do
    Pairing.count.should == 0
    @word.translations.count.should == 0

    @word.translations << @word2
    @word.translations.count.should == 1

    lambda { @word.translations << @word2 }.should raise_error(ActiveRecord::RecordInvalid)
    lambda { @word2.translations << @word }.should raise_error(ActiveRecord::RecordInvalid)
    @word.translations.count.should == 1
    @word2.translations.count.should == 1
  end
end
