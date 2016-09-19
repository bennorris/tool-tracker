class AddAvailableColumnToTools < ActiveRecord::Migration
  def change
    add_column :tools, :available, :boolean 
  end
end
