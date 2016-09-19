class AddColToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :contact_name, :string
    add_column :companies, :email, :string
    add_column :companies, :password_digest, :string
  end
end
