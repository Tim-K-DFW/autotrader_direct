class MainController < ApplicationController
  respond_to :html

  def index

  end

  def new
    @search = Search.new
    
  end

  def submit
    
    @search = Search.new(search_params)
    if @search.validate
      @search.perform_search

      render 'results'
    else
      redirect_to :new
    end
    # binding.pry
  end

  private

    def search_params
      params.require(:search).permit!
    end

end