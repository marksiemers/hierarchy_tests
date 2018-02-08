require 'benchmark'

namespace :benchmark do
  task :read => :environment do
    titles = Employee.all.uniq.pluck(:title) & Worker.all.uniq.pluck(:title)
    employees = []
    titles.each do |title|
      employee_count = Employee.where(title: title).count
      worker_count = Worker.where(title: title).count
      count = [employee_count, worker_count].min
      offset = rand(0...count)
      employee = Employee.where(title: title).offset(offset).first
      worker = Worker.find_by(id: employee.id)
      redo unless employee.name == worker.name
      redo if (employee.descendants.size == 0 && employee.title != "Apprentice")
      employees << employee
    end
    ids = employees.sort_by(&:depth).map(&:id)

    ids.each do |id|
      employee, worker = Employee.find(id), Worker.find(id)
      puts "Trials for"
      puts "employee: #{employee.name}, #{employee.title} (id: #{employee.id}, depth: #{employee.depth})"
      puts "worker  : #{worker.name}, #{worker.title} (id: #{worker.id}, depth: #{employee.depth})"

      Benchmark.bmbm do |x|
        n = 100
        [:parent, :root, :depth].each do |method|
          x.report("ancestry.#{method}.to_s") do
            n.times { Employee.find(id).send(method).to_s }
          end
          x.report("closure_tree.#{method}.to_s") do
            n.times { Worker.find(id).send(method).to_s }
          end
        end

        [:ancestors, :children, :siblings, :descendants].each do |method|
          puts "employee: employee.#{method}.count (#{employee.send(method).count})"
          puts "worker  : worker.#{method}.count (#{worker.send(method).count})"
          n = (method == :descendants) ? 10 : 100
          x.report("ancestry.#{method}.to_a") do
            n.times { Employee.find(id).send(method).to_a }
          end
          x.report("closure_tree.#{method}.to_a") do
            n.times { Worker.find(id).send(method).to_a }
          end
          x.report("ancestry.#{method}.pluck(:id)") do
            n.times { Employee.find(id).send(method).pluck(:id) }
          end
          x.report("closure_tree.#{method}.pluck(:id)") do
            n.times { Worker.find(id).send(method).pluck(:id) }
          end
          x.report("ancestry.#{method}.size") do
            n.times { Employee.find(id).send(method).size }
          end
          x.report("closure_tree.#{method}.size") do
            n.times { Worker.find(id).send(method).size }
          end
          x.report("ancestry.#{method}.count") do
            n.times { Employee.find(id).send(method).count }
          end
          x.report("closure_tree.#{method}.count") do
            n.times { Worker.find(id).send(method).count }
          end # x.report
        end # [...].each do |method|
      end # Benchmark.bmbm
    end # ids.each do |id|
  end # task
end # namespace
