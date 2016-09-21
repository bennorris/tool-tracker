class EmployeeController < ApplicationController

  post '/employees/new' do
    @employee = Employee.new(params[:employee])
    @company = Company.find_by(name: params[:company])
    @company.employees << @employee
    @company.save
    @employee.save

    redirect to "/company/#{@company.slug}"
  end

  get '/employees/:slug' do
    if logged_in?
      @employee = Employee.find_by(first_name: params[:slug].split('-')[0], last_name: params[:slug].split('-')[1])
      @company = Company.find_by_id(session[:user_id])

      erb :'employee/show'
    else
      redirect to '/login'
    end  
  end

  post '/employees' do
    @employee = Employee.find_by_id(params[:id])
    @employee.update(params[:employee])
    @employee.save

    @company = Company.find_by_id(session[:user_id])

    redirect to "/company/#{@company.slug}"
  end



end
