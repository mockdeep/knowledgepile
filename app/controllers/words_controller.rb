class WordsController < ApplicationController
  def index
    @words = Word.language('English').ranked.paginate(:page => params[:page])
  end

  def new
  end

  def quiz
    if params[:answer]
      last_word = Word.find_no_case(params[:word]).language('English').first
      if last_word.nil?
        flash.notice = "Sorry, something went wrong, please try again"
      elsif last_word.translates_to?(params[:answer], 'italiano')
        flash.notice = "Correct! #{last_word} => #{params[:answer]}"
      else
        flash.notice = "Wrong! #{last_word} => #{last_word.translate_to('italiano').first}"
      end
    end

    all_words = Word.language('English').ranked.not_orphaned
    words = []
    4.times do
      words << all_words.delete_at(rand(all_words.length))
    end
    @word = words.first.title
    @answers = []
    until words.empty?
      @answers << words.delete_at(rand(words.length)).translations.first.title
    end
  end
end
