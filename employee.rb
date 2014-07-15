class Employee
  attr_accessor :name, :title, :salary, :boss

  def initialize(name, title, salary, boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end

  def bonus(multiplier)
    self.salary * multiplier
  end
end

class Manager < Employee
  attr_accessor :employees

  def initialize(name, title, salary, boss)
    super(name, title, salary, boss)
    @employees = []
  end

  #bonus = (total salary of all employees and sub employees) * multiplier
  def bonus(multiplier)
    total = 0
    self.employees.each do |employee|
      total += employee.bonus(1)
    end
    total * multiplier
  end


end