class ChangeParentIdColumnInEmployees < ActiveRecord::Migration
  def change
    rename_column :employees, :parent_id, :my_parent_id
  end
end
