class Disposition
  attr_accessor :description, :start, :end
  
  def initialize(desc, start_time, end_time)
    @description = desc
    @start = start_time
    @end = end_time
  end
  
  def to_string
    "#{@description}|#{@start}|#{@end}|"
  end

  def to_screen
    output = "#{@description} Started at #{@start} and finished on #{@end}"
  end
end
