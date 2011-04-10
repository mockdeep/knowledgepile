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

  task :repeat_punct => :environment do
    match_string = '?:[:alnum:]{3,}'
    match_string = '([^[:alnum:]])\1+'
    Word.find_each do |word|
      if word.title.match(Regexp.new(match_string))
        puts "deleting --> #{word.title} <--"
        word.destroy
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

  task :rank_words => :environment do
    file = File.open('dictionaries/en-top-words.txt')
    strings1 = file.read.split("[[")
    missed_count = 0
    strings1.each_with_index do |string, index|
      strings2 = string.split("]]")
      next unless strings2.length > 1
      words = Word.find_all_no_case(strings2.first)
      if words.empty?
        word = Word.new(:title => strings2.first, :language => 'English')
      else
        word = words.first
      end
      word.rank = index
      word.save
      puts "#{word.rank}. #{word}"
    end
    puts "missed_count: #{missed_count}"
  end
end
