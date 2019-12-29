require_relative 'student'
require 'curses'

class DataBase
attr_reader :students
include Curses

  def initialize(students = [])
    @students = students
  end

  def add_student(name, cohort, student = Student)
    @students << student.new(name, cohort)
  end

  def print_by_cohort(cohort)
    category_invalid('cohort', cohort)
    print('cohort', cohort)
  end

  def print_by_name(letter)
    category_invalid('name', letter)
    print('name', letter)
  end

  def print_all
    print('true', 'all')
  end

  private

  def category_invalid(category, selection)
    raise "No matches found" if search(category, selection).empty?
  end

  def print_header
    puts "The students of Villains Academy".center(Curses::cols)
    puts "----------------------".center(Curses::cols)
  end

  def print(category, selection)
    Curses.init_screen
    print_header
    print_students(to_print(category, selection))
    print_footer
  end

  def search(category, selection)
    category == 'cohort' ? cohort_selection(selection) : name_selection(selection)
  end

  def to_print(category, selection)
    if category == 'all'
      @students
    elsif category == 'cohort'
      cohort_selection(selection)
    elsif category == 'name'
      name_selection(selection)
    end
  end

  def cohort_selection(selection)
    @students.select { |student| student.cohort.downcase == selection }
  end

  def name_selection(selection)
    @students.select { |student| student.name[0].downcase == selection }
  end

  # def to_print(category, selection)
  #   if selection == 'all'
  #     @students
  #   else
  #     @students.select { |student| 
  #       category == 'cohort' ? category = student.cohort : category = student.name[0]
  #       category.downcase == selection
  #   }
  #   end
  # end

  def print_students(array)
    array.each_with_index { |student, idx|
      puts "#{idx + 1}. #{student.name} (#{student.cohort} cohort)".center(Curses::cols)
    }
  end

  def print_footer
    if @students.count == 1
      puts "Overall, we have #{@students.length} great student".center(Curses::cols)
    else
      puts "Overall, we have #{@students.length} great students".center(Curses::cols)
    end
  end
end
