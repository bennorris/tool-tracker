class EmployeeController < ApplicationController

  get '/employee/signup' do #employee side
    if company_logged_in? && @company.slug == params[:slug]
      erb :'company/show'
    elsif company_logged_in?
      redirect to "/company/#{@company.slug}"
    else
    erb :'employee/signup'
  end
  end

  post '/employees/new' do   #admin side
    params[:employee][:password] = "placeholder"
    @employee = Employee.new(params[:employee])
    @company = Company.find_by_id(session[:company_id])
    @company.employees << @employee
    @company.save
    @employee.save
    redirect to "/company/#{@company.slug}"
  end

  get '/employee/:slug' do #employee side
    @employee = Employee.find_by_id(session[:employee_id])
    @company = Company.find_by_id(@employee.company_id)
    if employee_logged_in?
      erb :'employee/show_profile'
    else
      redirect to '/login'
    end
  end

  post '/employee/new' do #employee side signup
    @company = Company.find_by(name: params[:company_name])

    Employee.all.each do |employee|
      if employee.contact_info == params[:employee][:contact_info]
        @employee = employee
      end
    end

    if @company && @employee || @employee && !@company
      session[:employee_id] = @employee.id
      @employee.update(params[:employee])
      redirect to "/employee/#{@employee.slug}"
    elsif @company && !@employee
      session[:company_id] = @company.id
      redirect to '/employee/signup/employee-not-registered'
    elsif !@company && !@employee #company hasn't registered yet and employee hasnt been created
      redirect to '/employee/signup/company-not-registered'
    end
  end

  get '/employee/signup/company-not-registered' do
    erb :'employee/company_not_registered'
  end

  get '/employee/signup/employee-not-registered' do
    @company = Company.find_by_id(session[:company_id])
    erb :'employee/employee_not_registered'
  end


  get '/employees/:slug' do #admin side
    @employee = Employee.find_by(first_name: params[:slug].split('-')[0], last_name: params[:slug].split('-')[1])
    @company = Company.find_by_id(session[:company_id])

    if company_logged_in? && @company.employees.include?(@employee)
      erb :'employee/show'
    elsif company_logged_in?
      redirect to "/company/#{@company.slug}"
    else
      redirect to '/login'
    end
  end

  post '/employees' do #admin side
    @employee = Employee.find_by_id(params[:id])
    @employee.update(params[:employee])
    @employee.save

    @company = Company.find_by_id(session[:company_id])

    redirect to "/company/#{@company.slug}"
  end

  post '/employee/edited' do
    @employee = Employee.find_by_id(session[:employee_id])
    @employee.first_name = params[:employee][:first_name]
    @employee.last_name = params[:employee][:last_name]
    @employee.contact_info = params[:employee][:contact_info]
    @employee.save

    redirect to "/employee/#{@employee.slug}"
  end



end
