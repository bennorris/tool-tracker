class EmployerController < ApplicationController


post '/employees/new' do
  if params[:employee]
    strip_params(params[:employee])
  end
  params[:employee][:password] = "placeholder"
  @company = Company.find_by_id(session[:company_id])
  @company.employees.create(params[:employee])
  redirect to "/company/#{@company.slug}"
end

get '/employees/:slug' do
  @employee = Employee.find_by(first_name: params[:slug].split('-')[0], last_name: params[:slug].split('-')[1])
  if company_logged_in? && @company.employees.include?(@employee)
    @employee_tools = @employee.tools
    erb :'employer/show_employee'
  else
    redirect to '/login'
  end
end

post '/employees' do
  @employee = Employee.find_by_id(params[:id])
  if company_logged_in? && @company.employees.include?(@employee)
    @employee = Employee.find_by_id(params[:id])
    @employee.update(params[:employee])
    redirect to "/company/#{@company.slug}"
  end
end


get '/employee/delete/:id' do
  @employee = Employee.find_by_id(params[:id])
  if company_logged_in? && @company.employees.include?(@employee)
    erb :'employer/delete_employee'
  else
    redirect to '/login'
  end
end

get '/employee/confirm-delete/:id' do
  @employee = Employee.find_by_id(params[:id])
  if company_logged_in? && @company.employees.include?(@employee)
    Employee.delete(@employee)
    redirect to "/company/#{@company.slug}"
  else
    redirect to '/login'
  end
end

end
