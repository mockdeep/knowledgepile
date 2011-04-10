namespace :dict do

  desc 'imports a text dictionary, splitting on tabs for languages, semicolons for alternatives'
  task :italian => :environment do
    parser = DictionaryParser.new('English', 'italiano')
    parser.parse_dictionary('dictionaries/eng-ital.txt')
    parser.parse_dictionary('dictionaries/english-italian.txt')
    parser.parse_dictionary('dictionaries/english-italian-2011-03-31.txt')
    parser.parse_dictionary('dictionaries/eng-ital-proper.txt')
  end

  task :rm_orphans => :environment do
    Pairing.find_each do |pairing|
      if pairing.word.nil? || pairing.translation.nil?
        puts "destroying pairing #{pairing.id}"
        pairing.destroy
      end
    end
  end

  task :bad_punct => :environment do
    match_string = '^[:alnum:]'
    Word.find_each do |word|
      mtch = word.title.match(Regexp.new("[#{match_string}-]"))
      if mtch
        puts "Word matches: #{word.title}"
        puts "(d)elete this word or (a)dd it's matches to the regex"
        response = STDIN.gets.chomp
        if response == 'd'
          puts "deleting word"
          word.destroy
        else
          puts "adding regex items"
          while mtch = word.title.match(Regexp.new("[#{match_string}-]"))
            mtch.to_a.each do |item|
              match_string << item
            end
          end
          puts "new regex string: #{match_string}"
        end
      end
    end
  end

  task :auto_bad_punct => :environment do
    match_string = '^[:alnum:] \'åöùà()ì,.ŵāéôčüõèÄò/Åä?š!:şíçºАžÀČÁěŠëṇ×ḤōúáūîćðŌň#ßṢṃăś&ṣ"ī'
    Word.find_each do |word|
      mtch = word.title.match(Regexp.new("[#{match_string}-]"))
      if mtch
        puts "deleting word: #{word.title}"
        word.destroy
      end
    end
  end

  task :replace_quotes => :environment do
    Word.find_each do |word|
      mtch = word.title.match(/[’]/)
      if mtch
        ex_word = word.title
        word.title = word.title.gsub('’', "'")
        word.save
        puts "quotes: replaced \"#{ex_word}\" with \"#{word.title}\""
      end
    end
  end

  task :replace_dashes => :environment do
    Word.find_each do |word|
      mtch = word.title.match(/[–]/)
      if mtch
        ex_word = word.title
        word.title = word.title.gsub('–', '-')
        word.save
        puts "dashes: replaced \"#{ex_word}\" with \"#{word.title}\""
      end
    end
  end
end
