class Worker < ActiveRecord::Base
  has_closure_tree

  def name
    "#{first_name} #{last_name}"
  end
end
