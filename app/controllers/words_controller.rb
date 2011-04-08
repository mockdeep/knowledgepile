class WordsController < ApplicationController
  def index
    @words = Word.language('English').paginate(:page => params[:page])
  end

  def new
  end

end
