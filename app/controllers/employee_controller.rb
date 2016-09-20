class EmployeeController < ApplicationController

  post '/employee/new' do
    @employee = Employee.new(params[:employee])
    @company = Company.find_by(name: params[:company])
    @company.employees << @employee
    @company.save
    @employee.save

    redirect to "/company/#{@company.slug}"
  end

  get '/employees/:slug' do
    @employee = Employee.find_by(first_name: params[:slug].split('-')[0], last_name: params[:slug].split('-')[1])
    erb :'employee/show'
  end



end
