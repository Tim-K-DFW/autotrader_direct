class Report
  include ActiveModel::Model
  
  attr_accessor :valid, :items, :timeframe
  attr_accessor :prod_yr1, :payout_yr1, :prod_growth_rate    # for form only
  validates :prod_yr1, presence: true, numericality: { only_integer: true }
  validates :payout_yr1, presence: true, numericality: { only_integer: true }

  
  def initialize(params = nil)
    @items = {}
    if params
      temp = {}
      temp[:name] = 'Production'
      temp[:values] = {}
      temp[:values][1] = params[:prod_yr1].to_i
      temp[:growth_rate] = params[:prod_growth_rate].to_f / 100
      items[:production] = temp
      @timeframe = params[:timeframe].to_i
    end
  end

  def validate
    self.valid = true
  end

  def create_report
    items.each do |item|
      (2..timeframe).each do |year|
        item[1][:values][year] = item[1][:values][year - 1] * (1 + item[1][:growth_rate])
      end  
    end

  end
   
 end