class DictionaryParser

  def initialize(l1, l2)
    @lang1 = l1
    @lang2 = l2
    Language.find_or_create_by_title(@lang1)
    Language.find_or_create_by_title(@lang2)
  end

  def parse_dictionary(file_name)
    dictionary = File.open(file_name)
    puts "parsing file #{file_name}"
    dictionary.each do |line|
      left_side, right_side = line.split("\t")
      raise "missing translation for: #{left_side}" if right_side.empty?
      words1 = left_side.split(';')
      words2 = right_side.split(';')
      words1.each do |word|
        word.strip!
        this_word = Word.language(@lang1).find_no_case(word).first
        if this_word.nil?
          this_word = Word.new(:title => word, :language => @lang1)
          this_word.save!
        end
        words2.each do |translation|
          translation.strip!
          that_word = Word.language(@lang2).find_no_case(translation).first
          if that_word.nil?
            that_word = Word.new(:title => translation, :language => @lang2)
            that_word.save!
          end
          begin
            this_word.translations << that_word
          rescue
            puts "words already paired: #{this_word.title} - #{that_word.title}"
          end
        end
      end
    end
  end
end
