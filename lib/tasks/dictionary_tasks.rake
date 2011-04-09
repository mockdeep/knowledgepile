namespace :dictionary do

  desc 'imports a text dictionary, splitting on tabs for languages, semicolons for alternatives'
  task :import_italian => :environment do
    parser = DictionaryParser.new('English', 'italiano')
    parser.parse_dictionary('dictionaries/eng-ital.txt')
    parser.parse_dictionary('dictionaries/english-italian.txt')
    parser.parse_dictionary('dictionaries/english-italian-2011-03-31.txt')
    parser.parse_dictionary('dictionaries/eng-ital-proper.txt')
  end
end
