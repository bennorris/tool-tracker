class CreateEmployeeTools < ActiveRecord::Migration
  def change
    create_table :employee_tools do |t|
      t.integer :employee_id
      t.integer :tool_id
    end
  end
end
