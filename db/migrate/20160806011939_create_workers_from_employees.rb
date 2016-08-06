class CreateWorkersFromEmployees < ActiveRecord::Migration
  def change
    sql =
    <<-SQL
      SELECT id, first_name, last_name, title, start_date, end_date, active,
      created_at, updated_at, my_parent_id
      INTO public.workers
      FROM public.employees
    SQL
    ActiveRecord::Base.connection.execute(sql)
  end
end
