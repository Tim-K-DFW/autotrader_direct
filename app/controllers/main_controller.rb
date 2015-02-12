class MainController < ApplicationController
  respond_to :html, :js

  def index

  end

  def new
    @search = Search.new
    # @search.add_makes_list          to add drop-down make selector in the future
  end

  def submit
    @search = Search.new(search_params)
    if @search.valid?
      @search.perform_search
      render 'results'
    else
      render 'new'
    end
  end

  def sort                          # only triggered by ajax call, needs the results array
    @search = Search.new
    @search.results = params[:results]
    @search.sort_order = params[:sort_order]
    @search.sort_direction = params[:sort_direction]
    @search.sort
    respond_to do |f|
      f.js {render 'results'}
    end
  end

  def models            # only triggered by ajax call
    @model = params[:make]
    respond_to do |f|
      f.js {render 'models'}
    end
  end

  private

    def search_params
      params.require(:search).permit!
    end

end