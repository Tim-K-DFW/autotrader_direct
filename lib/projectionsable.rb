module Projectionsable

  class Projection
    attr_accessor :items, :timeframe

  #   # goal - keep results ready for output
  #   # has several items/members
  #   # has time span

    def initialize
      self.items = {}
    end

    def add_item(item)
      self.items[item.name] = item
    end

    def change_timeframe(timeframe)
      self.timeframe = timeframe
    end


  #   def add_item(item)
  #   def remove_item(item)
  # 
    def generate
      if self.items.size < 1 || !timeframe
        puts "Need to have at least one item and timeframe"
        
      else
        items.each do |k, v|
          (2..timeframe).each do |year|
            new_key = 'yr' + year.to_s + '_value'
            prev_key = 'yr' + (year - 1).to_s + '_value'
            binding.pry
            # v.send(new_key) = v.send(prev_key) * (1 + yr1_growth_rate)


            # every item is an object, not a hash - i.e. we can't add an item the same way we do with hashes
            # probably, will need to represent items with plain hashes, as opposed to objects
            
          end  
        end
      end

    end
  #     no args, will require that items and time_span assigned

  end



  class ProjectionItem
    attr_accessor :name, :description, :yr1_value, :yr1_growth_rate

    def initialize(args)
      @name = args[:name]
      @description = args[:description]
      @yr1_value = args[:yr1_value]
      @yr1_growth_rate = args[:yr1_growth_rate]
    end

    def add_record(key, value)
      self[key] = value
    end

  end

end