class Student
  def initialize(name, cohort = "november")
    @name = name.capitalize
    @cohort = cohort.to_sym
  end

  def details
    [@name, @cohort]
  end
end