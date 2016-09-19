class Tool < ActiveRecord::Base
  belongs_to :company
  has_many :employees, through: :company
end
