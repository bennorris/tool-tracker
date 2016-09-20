class Company < ActiveRecord::Base
  has_secure_password
  has_many :employees
  has_many :tools

  def slug
    self.name.gsub(" ", "-")
  end

  def self.delete_all_now
    self.all.each do |company|
      company.delete
    end
  end

end
