class Student
  attr_reader :name, :cohort

  def initialize(name, cohort = "november")
    @name = name.capitalize
    @cohort = cohort.capitalize
  end

  #add a spell checker for cohort


end
