class Tool < ActiveRecord::Base
  belongs_to :company
  has_many :employee_tools
  has_many :employees, through: :employee_tools

  def slug
    self.product.gsub(" ", "-")
  end

end
