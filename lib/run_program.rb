require_relative 'database'
require 'csv'

HEADER = ["Name", "Cohort"]

def main_menu_process(selection)
  case selection
    when "1" 
     input_students
    when "2"
      print_menu 
      show_students(STDIN.gets.chomp)
    when "3" 
      puts "Would you like to:\n1. Add students to an existing file\n2. Save to a new file"
      choice = STDIN.gets.chomp
      puts "Enter the name of the file to append/create/overwrite\nReturn to use students.csv (default)"
      filename = filename_choice
      choice == "1" ? save_students(filename, "a+") : save_students(filename, "w+")
    when "4"
      puts "Enter the name of the file to load\nReturn twice to use students.csv (default)"
      filename = filename_choice
      load_students(filename)
      puts "Successfully loaded students from #{filename}"
    when "9"
      exit 
    else
      puts "I don't know what you meant, try again"
  end
end

def save_students(filename, write_mode)
  CSV.open("./#{filename}", write_mode) do |csv|
    if write_mode == "w+"
      csv << HEADER
    end
    @database.students.each { |student| 
      csv << [student.name, student.cohort]    
    }
  end
    puts "Students saved to #{filename}"
end

def load_students(filename = "students.csv")
  @database = DataBase.new
  CSV.foreach("./#{filename}") do |row|
     name, cohort = row
    @database.add_student(name, cohort) if row != HEADER
   end
   puts "Loaded #{@database.students.count} from #{filename}"
end

def default_load_students
 filename = ARGV.first
 if ARGV.first.nil? || !File.exist?(filename) #short circuit evaluation
   filename = "students.csv"
   puts "File not found or no filename given"
 end
 load_students(filename)
end
  
def interactive_menu
  loop do
    main_menu
    main_menu_process(STDIN.gets.chomp)
  end
end

def print_menu
  puts "1. Print by cohort"
  puts "2. Print by name"
  puts "3. Print all"
end

def main_menu
  puts "1. Input the students" 
  puts "2. Show the students" 
  puts "3. Save the list to a file"
  puts "4. Load the list from a file"
  puts "9. Exit"
end

def input_students
  puts "Please enter the names of the students:"
  puts "To finish, just hit return"
  name = STDIN.gets.strip!
  while !name.empty? do
    puts "Please enter a cohort (return for default: november):"
    cohort = STDIN.gets.strip!
    puts "You have entered: #{cohort.empty? ? 'november' : cohort}. If this is correct return twice, otherwise please re-enter: "
    cohort_2 = STDIN.gets.strip!
      if cohort_2.empty?
        cohort = 'november' if cohort.empty?
      else
        cohort = cohort_2
      end
    @database.add_student(name, cohort)
    puts "Please enter the names of the students:"
    puts "To finish, just hit return"
    name = STDIN.gets.strip!
  end
end

def show_students(selection)
  case selection 
  when '1' 
    puts 'Enter a cohort'
    choice = STDIN.gets.chomp
    @database.print_by_cohort(choice)
  when '2'
    puts 'Enter a letter'
    choice = STDIN.gets.chomp
    @database.print_by_name(choice)
  when '3'
    @database.print_all
  end
end

def filename_choice
  filename_choice = STDIN.gets.chomp
  filename_choice == "" ? "students.csv" : filename_choice
end


default_load_students
interactive_menu