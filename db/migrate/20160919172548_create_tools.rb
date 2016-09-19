class CreateTools < ActiveRecord::Migration
  def change
    create_table :tools do |t|
      t.string :manufacturer
      t.string :model
      t.string :category
      t.integer :company_id
    end
  end
end
