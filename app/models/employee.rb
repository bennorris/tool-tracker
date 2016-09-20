class Employee < ActiveRecord::Base
  belongs_to :company
  has_many :tools, through: :company

  def name
    self.first_name + " " + self.last_name
  end

  def slug
    name.gsub(" ", "-")
  end

end
