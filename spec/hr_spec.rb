require './hr.rb'

describe Candidate do
  it "should output a string" do
    c = Candidate.new
    x = c.to_string
    x.should eq("yz")
  end
end
