class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :first_name
      t.string :last_name
      t.string :title
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :active

      t.timestamps null: false
    end
  end
end
