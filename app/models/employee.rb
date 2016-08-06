class Employee < ActiveRecord::Base
  has_ancestry

  def name
    "#{first_name} #{last_name}"
  end
end
