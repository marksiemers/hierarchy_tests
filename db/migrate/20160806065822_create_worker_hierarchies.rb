class CreateWorkerHierarchies < ActiveRecord::Migration
  def change
    create_table :worker_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :worker_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "worker_anc_desc_idx"

    add_index :worker_hierarchies, [:descendant_id],
      name: "worker_desc_idx"
  end
end
