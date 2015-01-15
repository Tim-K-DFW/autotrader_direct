class MainController < ApplicationController
  respond_to :html, :js

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
  end

  def sort # only triggered by ajax call, needs the results array
    @search = Search.new
    @search.results = params[:results]
    @search.sort_order = params[:sort_order]
    respond_to do |f|
      f.js {render 'results'}
    end
  end

  private

    def search_params
      params.require(:search).permit!
    end

end