class WordsController < ApplicationController
  def index
    @words = Word.language('English').ranked.paginate(:page => params[:page])
  end

  def new
  end

end
