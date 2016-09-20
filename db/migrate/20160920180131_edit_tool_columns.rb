class EditToolColumns < ActiveRecord::Migration
  def change
    remove_column :tools, :manufacturer
    remove_column :tools, :model
    add_column :tools, :product, :string
    add_column :tools, :notes, :string
  end
end
