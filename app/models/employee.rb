class Employee < ActiveRecord::Base
  has_secure_password
  belongs_to :company
  has_many :employee_tools
  has_many :tools, through: :employee_tools

  def name
    self.first_name + " " + self.last_name
  end

  def slug
    name.gsub(" ", "-")
  end

  def self.delete_all_now
    self.all.each do |employee|
      employee.delete
    end
  end

end
