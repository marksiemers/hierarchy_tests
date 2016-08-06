class AddIndexToParentIdOnWorkers < ActiveRecord::Migration
  def change
    add_index :workers, :parent_id
  end
end
