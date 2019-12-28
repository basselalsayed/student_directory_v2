require 'csv'
@students = [] #an empty array accessible to all methods

def print_header
  puts "The students of Villains Academy".center(50)
  puts "----------------------".center(50)
end

def print_students_list
  if @students.length == 0
    puts "There are no students to print"
    nil
  else
    puts "Would you like to group by cohort or sort by name?"
    answer = STDIN.gets.strip!
    if answer == "cohort"
      grouped_by_cohort = Hash.new { |h, k| h[k] = [] }
      @students.each { |person| grouped_by_cohort[person[:cohort]] << person }
      puts "If you would like to see a specific cohort, enter the month below. Otherwise return twice to see all grouped"
      choice = STDIN.gets.chomp!
      if choice.empty?
        print_header
        c = 0
        grouped_by_cohort.each { |cohort, person| 
          person.each { |i| 
          puts %{
            #{(c + 1)}. #{i[:name]} (#{i[:cohort]} cohort)
               Hobbies: #{i[:hobbies]} 
               Country: #{i[:country]} 
               Height: #{i[:height]} cm}.center(50)  
          c += 1
        }}
      else
        print_header
        c = 0
        grouped_by_cohort.each { |cohort, person| 
          person.each { |i| 
          puts %{
            #{(c + 1)}. #{i[:name]} (#{i[:cohort]} cohort)
               Hobbies: #{i[:hobbies]} 
               Country: #{i[:country]} 
               Height: #{i[:height]} cm}.center(50)  if i[:cohort] == choice.to_sym
          c += 1
        }}
      end

    else
      puts "Would you like to print all students or by a specific letter?"
      selection = STDIN.gets.capitalize.strip!
      print_header
      i = 0
      until i == @students.length
        if i == @students.length 
          break
        else
          if @students[i][:name].length < 12
            if selection != "All" 
              puts %{
              #{(i + 1)}. #{@students[i][:name]} (#{@students[i][:cohort]} cohort)
                Hobbies: #{@students[i][:hobbies]} 
                Country: #{@students[i][:country]} 
                Height: #{@students[i][:height]} cm}.center(50) if @students[i][:name][0] == selection
            else
              puts %{
              #{(i + 1)}. #{@students[i][:name]} (#{@students[i][:cohort]} cohort)
                 Hobbies: #{@students[i][:hobbies]} 
                 Country: #{@students[i][:country]} 
                 Height: #{@students[i][:height]} cm}.center(50)
            end
            i += 1
          end
        end
      end
    end
  end
end

def print_footer
  if @students.count == 1
    puts "Overall, we have #{ @students.count } great student"
  else
    puts "Overall, we have #{ @students.count } great students"
  end
end

def input_students
  puts "Please enter the names of the student:"
  puts "To finish, just hit return twice"
  name = STDIN.gets.strip!
    while !name.empty? do
      puts "Please enter a cohort (return twice for default: november):"
      cohort = STDIN.gets.strip!
      puts "You have entered: #{cohort}. If this is correct return twice, otherwise please re-enter: "
      cohort_2 = STDIN.gets.strip!
        if cohort_2.empty?
          cohort = :november if cohort.empty?
        else
          cohort = cohort_2
        end
      puts "Please enter the hobbies (return twice to finish):"
      hobbies = []
      hobby = STDIN.gets.strip!
        while !hobby.empty? do
          hobbies << hobby.capitalize!
          hobby = STDIN.gets.strip!
        end
      puts "Please enter country of birth"
      country = STDIN.gets.strip!
      puts "Please enter height"
      height = STDIN.gets.strip!
      @students << { name: name.capitalize!, cohort: cohort.to_sym, hobbies: hobbies, country: country.capitalize!, height: height }
      puts "Now we have #{@students.count} students"
      puts "Please enter the names of the student"
      puts "To finish, just hit return twice"
      name = STDIN.gets.strip!
    end
end

def print_menu #1. print the menu and ask the user what to do
  puts "1. Input the students" 
  puts "2. Show the students" 
  puts "3. Save the list to a file"
  puts "4. Load the list from a file"
  puts "9. Exit"
end

def show_students #2. read the input and save it into a variable
  print_students_list
  print_footer
end

def process(selection) #provides option for moving through the menu
  case selection
    when "1" 
     input_students
    when "2" 
      show_students
    when "3" 
      save_students
    when "4"
      @students = []
      puts "Enter the name of the file to load\nReturn twice to use students.csv (default)"
      filename = filename_choice
      load_students(filename) #loads students.csv
      puts "Successfully loaded students from #{filename}"
    when "9"
      exit 
    else
      puts "I don't know what you meant, try again"
  end
end

# def save_students
#   puts "Enter the name of the file to save\nReturn twice to use students.csv (default)"
#   filename = filename_choice
#   File.open(filename, "w") do |file| #open the file for writing
#   #iterate over the array of students and add each line to a new file
#   @students.each do |student|
#     student_data = [student[:name], student[:cohort], student[:hobbies].join('-'), student[:country], student[:height]]
#     csv_line = student_data.join(",")
#     file.puts csv_line 
#   end
#   end
#     puts "Students saved to students.csv"
# end

def save_students
  puts "Enter the name of the file to save\nReturn twice to use students.csv (default)"
  filename = filename_choice
  header_row = @students[0].each_with_object([]) { |(k, v), arr | arr << k.to_s.capitalize }
  header = CSV.open("#{filename}", 'r') { |csv| csv.first }
  CSV.open("./#{filename}", "w") do |csv|
    csv << header_row if header != header_row
    @students.each { |student| 
      csv << [student[:name], student[:cohort].to_s.capitalize, student[:hobbies].join('-'), student[:country], student[:height]]    
    }
  end
  puts "Students saved to #{filename}"
end

def filename_choice
  filename_choice = STDIN.gets.chomp
  filename_choice == "" ? "students.csv" : filename_choice
end

def load_students(filename = "students.csv")
 CSV.foreach("./#{filename}") do |row|
    name, cohort, hobbies, country, height = row
   @students << {name: name, cohort: cohort.to_sym, hobbies: hobbies.split('-'), country: country, height: height }
  end
  puts "Loaded #{@students.count} from #{filename}"
end


def try_load_students
  filename = ARGV.first
  if ARGV.first.nil? || !File.exist?(filename) #short circuit evaluation
    filename = "students.csv"
  end
  puts "File not found or no filename given"
  load_students(filename)
  
end

def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

try_load_students
interactive_menu
