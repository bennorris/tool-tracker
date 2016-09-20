class Tool < ActiveRecord::Base
  belongs_to :company
  has_many :employee_tools
  has_many :employees, through: :employee_tools

  def self.delete_all_now
    self.all.each do |tool|
      tool.delete
    end
  end

  def slug
    self.manufacturer.gsub(" ", "-")
  end

end
