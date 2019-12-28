require_relative 'student'

class DataBase
attr_reader :students

  def initialize(students = [])
    @students = students
  end
end
