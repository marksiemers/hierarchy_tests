class RenameMyParentIdToParentId < ActiveRecord::Migration
  def change
    rename_column :workers, :my_parent_id, :parent_id
  end
end
