class Company < ActiveRecord::Base
  has_secure_password
  has_many :employees
  has_many :tools
  validates_presence_of :name, :contact_name, :email, :password

  def slug
    self.name.gsub(" ", "-")
  end

end
