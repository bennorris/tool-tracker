class EmployeeTool < ActiveRecord::Base
  belongs_to :employee
  belongs_to :tool
end
