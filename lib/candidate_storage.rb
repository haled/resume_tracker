class CandidateStorage
  
  attr_accessor :filename, :candidates, :max_key

  def initialize(file_name)
    @filename = file_name
  end

  def save
    File.open(@filename, "w") do |file|
      @candidates.each_key { |key| file.puts @candidates[key].to_string }
    end
  end

  def load
    key = 0
    @candidates = Hash.new
    if(File.exists?(@filename)) then
      File.open(@filename) do |file|
        file.each do |line|
          new_candidate = Candidate.new
          new_candidate.populate(line)
          @candidates[key] = new_candidate
          key += 1
        end
      end
    end
    @max_key = key
    @candidates
  end
end

