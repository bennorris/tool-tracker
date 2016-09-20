class AddContactToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :contact_info, :string  
  end
end
