class Candidate
  attr_accessor :first_name, :last_name, :middle, :position, :source, :salary_expectations, :dispositions

  def initialize
    @dispositions = Array.new
  end

  def populate(single_line)  # populate
    main_fields = single_line.split(",")
    @first_name = main_fields[0]
    @last_name = main_fields[1]
    @middle = main_fields[2]
    @position = main_fields[3]
    @source = main_fields[4]
    @salary_expectations = main_fields[5]
    separated_dispositions = main_fields[6].split("$")
    separated_dispositions.each do |obj|
      disp_fields = obj.split("|")
      new_disposition = Disposition.new(disp_fields[0].chomp, disp_fields[1].chomp, disp_fields[2].chomp)
      @dispositions.push(new_disposition)
    end
  end

  def to_string
    output = "#{@first_name},#{@last_name},#{@middle},#{@position},#{@source},#{@salary_expectations},"
    for i in 0..@dispositions.length-1 do
      output += "#{dispositions[i].to_string}"
      if(i != @dispositions.length-1) then
        output += "$"
      end
    end
    return output
  end

  def to_screen(counter)
    output = ""
    output += "#{counter}.\n"
    output += "Name:  #{@first_name} #{@middle} #{@last_name}\n"
    output += "Position:  #{@position}\n"
    output += "Source:  #{@source}\n"
    output += "Salary:  #{@salary_expectations}\n"
    output += "Disposition:\n"
    @dispositions.each { |disposition| output += "\t#{disposition.to_screen}\n" }
    return output
  end

  def add_new_disposition(desc, start_time)
    @dispositions.each do |disposition|
      if(disposition.end == nil || disposition.end.to_s.empty?) then
        disposition.end = start_time
        break
      end
    end
    new_disposition = Disposition.new(desc, start_time, nil)
    @dispositions.push(new_disposition)
  end
end
