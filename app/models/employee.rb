class Employee < ActiveRecord::Base
  has_ancestry

  belongs_to :my_parent, class_name: :Employee
  has_many :employees, foreign_key: :my_parent_id
end
