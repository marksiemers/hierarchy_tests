# Set how many test employees we want to setup
# Setup may take up to 1 second per 100 records,
EMPLOYEE_TEST_POPULATION = 1_000_000
YEARS_AGO_COMPANY_STARTED = 25

# Calculate how many we need to add
number_of_new_employees_to_create = EMPLOYEE_TEST_POPULATION - Employee.count

# Setup job titles - the hash is so we can bias to sampling lower level employees
JOB_TITLES_AND_RATIOS = {
  :'President' => 1,
  :'Country Director' => 3,
  :'Area Director' => 8,
  :'Regional Director' => 16,
  :'Site Director' => 32,
  :'Managing Director' => 64,
  :'Director' => 128,
  :'Vice President' => 128,
  :'Manager' => 128,
  :'Lead Supervisor' => 128,
  :'Supervisor' => 128,
  :'Foreman' => 512,
  :'Senior Craftsman' => 1024,
  :'Journeyman' => 1024,
  :'Craftsman' => 2048,
  :'Apprentice' => 8192
}

JOB_TITLES = JOB_TITLES_AND_RATIOS.keys.map(&:to_s)
RATIOS = JOB_TITLES_AND_RATIOS.values
RATIO_TOTAL = RATIOS.reduce(:+)

# Like highlander, there can only be one CEO
ceo = Employee.find_by(title: 'CEO')
if ceo.blank?
  ceo = Employee.create(
    first_name: 'Tony',
    last_name: 'Stark',
    title: 'CEO',
    start_date: YEARS_AGO_COMPANY_STARTED.years.ago,
    end_date: nil,
    active: true,
    parent: nil,
    my_parent: nil
  )
end

CEO = ceo

def setup_employee_parent_and_save(employee)
  employee_parent_job_title_index = JOB_TITLES.index(employee.title) - 1

  if employee_parent_job_title_index == -1
    parent = CEO
  else
    employee_parent_job_title = JOB_TITLES[employee_parent_job_title_index]
    count = Employee.where(title: employee_parent_job_title).count
    offset = rand(0...count)
    parent = Employee.where(title: employee_parent_job_title).offset(offset).first
  end
  employee.parent = parent
  employee.my_parent = parent
  employee.save!
end

def show_progress(n)
  puts n if n % 1000 == 0
end

# Create at least one of every position (as much as possible, given total number of employees)
JOB_TITLES.each do |title|
  if Employee.find_by(title: title).blank?
    employee = Employee.new(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      title: title,
      start_date: Faker::Time.between(25.years.ago, Date.today, :all),
      end_date: nil,
      active: true
    )
    setup_employee_parent_and_save(employee)
  end
end

# Generate a fake employee to get to the correct test population
number_of_new_employees_to_create.times do |n|
  # Fake the baseline data

  # Get a sample title from the list (this ended up being over-engineered)
  sample_number = rand(RATIO_TOTAL)
  acc = 0
  title_index = 0
  RATIOS.each_with_index do |ratio,index|
    acc += ratio
    if sample_number <= acc
      title_index = index
      break
    end
  end

  title = JOB_TITLES[title_index]

  employee = Employee.new(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    title: title,
    start_date: Faker::Time.between(25.years.ago, Date.today, :all),
    end_date: nil,
    active: [true, true, true, true, false].sample,
  )

  employee.end_date = Faker::Time.between(employee.start_date, Date.today, :all) unless employee.active
  setup_employee_parent_and_save(employee)
  show_progress(n)
end
