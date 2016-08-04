class AddParentIdToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :parent_id, :integer
    add_index :employees, :parent_id
  end
end
