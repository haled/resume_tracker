require 'date'
require '../lib/candidate'
require '../lib/candidate_storage'
require '../lib/disposition'

Shoes.app do
  @storage = CandidateStorage.new("candidates.txt")
  @storage.load

  @statuses = ["New", "Phone Screen", "Interview", "References", "Pass", "Duplicate"]

  @open_button = button "Open"
  @add_button = button "Add"
  @find_button = button "Find"
  @list_button = button "List"
  @save_button = button "Save"
  @exit_button = button "Exit"

  def hide_all_stacks
    @add_stack.hide
    @list_stack.hide
    # @list_stack.clear
  end

  def update_disposition(disposition,candidate)
    candidate.add_new_disposition(disposition, Date.today)
  end

  def create_list_stack
    list_stack = stack do
      count = 1
      @storage.candidates.each_key do |key|
        @candidate_list = flow do
          para @storage.candidates[key].to_screen(count)
          count += 1
          flow do
            para "New Disposition:"
            disposition_list_box = list_box :items => @statuses
            update_button = button("Update") { update_disposition(disposition_list_box.text,@storage.candidates[key]) }
          end
          button("Edit") { alert("Test") }
        end
      end
      # close button if we figure out how
    end
    return list_stack
  end

  def test_window
    my_window = window do
      stack do
        para "Hola Mundo!"
        button("Close") do
          my_window.clear
          my_window.remove
        end
      end
    end
  end

  def create_add_stack
    add_stack = stack do
      flow do
        para "First Name:"
        @first_name = edit_line
      end
      flow do
        para "Last Name:"
        @last_name = edit_line
      end
      flow do
        para "Middle:"
        @middle = edit_line
      end
      flow do
        para "Position:"
        @position = edit_line
      end
      flow do
        para "Recruiter:"
        @recruiter = edit_line
      end
      flow do
        para "Salary:"
        @salary = edit_line
      end
      @add_candidate_button = button ("Add Candidate") do
        new_candidate = Candidate.new
        new_candidate.first_name = @first_name.text
        new_candidate.last_name = @last_name.text
        new_candidate.middle = @middle.text
        new_candidate.position = @position.text
        new_candidate.source = @recruiter.text
        new_candidate.salary_expectations = @salary.text
  
        today = Date.today
        new_disposition = Disposition.new("New", today, nil)
        new_candidate.dispositions.push(new_disposition)
        @storage.max_key += 1
        new_key = @storage.max_key
        @storage.candidates[new_key] = new_candidate
  
        #hide_all_stacks
      end
    end
    return add_stack
  end

  @list_stack = create_list_stack
  @add_stack = create_add_stack

  @open_button.click do
    file_open_dialog = dialog do
      flow do
        para "File Name:"
        file_name = edit_line
        open_file_button = button "Open"
        open_file_button.click do
          @storage = CandidateStorage.new(file_name.text)
          file_open_dialog.clear
          file_open_dialog = nil
        end
      end
    end
  end

  @add_button.click do
    hide_all_stacks
#    @add_stack.show
    @add_stack = create_add_stack
  end

  @list_button.click do
    hide_all_stacks
#    @list_stack.show
    @list_stack = create_list_stack
  end

  @save_button.click do
    @storage.save
    hide_all_stacks
  end

  @find_button.click do
    test_window
  end

  @exit_button.click do
    exit
  end

  hide_all_stacks
end
