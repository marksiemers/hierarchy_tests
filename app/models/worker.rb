class Worker < ActiveRecord::Base
  has_closure_tree

  #belongs_to :parent, class_name: :Worker
  #has_many :workers, foreign_key: :parent_id
end
