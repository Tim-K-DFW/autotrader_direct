class ReportsController < ApplicationController
  respond_to :html

  def index

  end

  def new
    @report = Report.new
    
  end

  def create
    # try to save inputs to report's fields (add validations)
    # if save successful, call generation method and render output, passing output in a hash - no other controller
    # otherwise, redirect to input

    @report = Report.new(report_params)
    if @report.validate
      @report.create_report

      render 'report'
    else
      redirect_to :new
    end
    # binding.pry
  end

  private

    def report_params
      params.require(:report).permit!
    end

end