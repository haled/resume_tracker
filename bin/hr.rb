require 'date'
require 'lib/candidate'
require 'lib/candidate_storage'
require 'lib/disposition'

$stdin.sync = true

print_menu = "    HR Helper    "
print_menu += "\n\n"
print_menu += "1. Add candidate\n"
print_menu += "2. Find candidate\n"
print_menu += "3. Update candidate\n"
print_menu += "4. List candidates\n"
print_menu += "5. Save\n"
print_menu += "X. Exit\n"
print_menu += "\n\n"
print_menu += "Enter selection: "

if (ARGV[0] == nil) then 
  puts "Need to supply a file name as an argument."
  exit(1) 
end

storage = CandidateStorage.new(ARGV[0])
candidates = storage.load

continue_looping = true

while continue_looping do
  print print_menu
  choice = STDIN.gets()
  choice.chomp!

  if(choice == "X" || choice == "x") then
    continue_looping = false
  elsif(choice == "1") then
    storage.max_key += 1
    new_key = storage.max_key
    new_candidate = Candidate.new
    
    puts "Enter the First Name:"
    new_candidate.first_name = STDIN.gets()
    new_candidate.first_name.chomp!
    puts "Enter the Last Name:"
    new_candidate.last_name = STDIN.gets()
    new_candidate.last_name.chomp!
    puts "Enter the Middle Name/Initial:"
    new_candidate.middle = STDIN.gets()
    new_candidate.middle.chomp!
    puts "Enter the Position:"
    new_candidate.position = STDIN.gets()
    new_candidate.position.chomp!
    puts "Enter the Recruiter:"
    new_candidate.source = STDIN.gets()
    new_candidate.source.chomp!
    puts "Enter the Salary Requirements:"
    new_candidate.salary_expectations = STDIN.gets()
    new_candidate.salary_expectations.chomp!
    today = Date.today
    new_disposition = Disposition.new("New", today, nil)
    new_candidate.dispositions.push(new_disposition)
    storage.candidates[new_key] = new_candidate
    puts "Thank you."
  elsif(choice == "2") then
    found = false
    puts "Enter the name to search:"
    name = STDIN.gets()
    name.chomp!
    storage.candidates.each_key do |key|
      if(storage.candidates[key].first_name == name || storage.candidates[key].last_name == name) then
        puts storage.candidates[key].to_screen(key)
        found = true
        break
      end
    end
    if !found then puts "\n\nNot found.\n" end
  elsif(choice == "3") then
    puts "Select the candidate by number:"
    candidate_choice = STDIN.gets()
    candidate_choice.chomp!
    key = candidate_choice.to_i
    puts storage.candidates[key].to_screen(key)
    puts "\n\nEnter the new status:"
    status = STDIN.gets()
    status.chomp!
    storage.candidates[key].add_new_disposition(status, Date.today)
  elsif(choice == "4") then
    storage.candidates.each_key { |key| puts "#{candidates[key].to_screen(key)}" }
  elsif(choice == "5") then
    storage.save
  end

  puts "\n\n\n"
end

storage.save
