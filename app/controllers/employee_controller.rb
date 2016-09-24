class EmployeeController < ApplicationController

  get '/employee/signup' do #employee side
    if logged_in?
      logged_in?
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
    elsif company_logged_in?
      redirect to "/company/#{@company.slug}"
    else
      redirect to '/login'
    end
  end

  post '/employee/new' do #employee side signup
    if params[:employee]
      params[:employee].map do |key, value|
          value.strip!
        end
      end

  @company = Company.find_by(name: params[:company_name])
  @employee = Employee.find_by(contact_info: params[:employee][:contact_info])

    if params[:employee][:password] != params[:password_confirmation]
      flash[:password_mismatch] = "Please enter matching passwords."
      redirect to '/employee/signup'
    elsif @employee
      session[:employee_id] = @employee.id
      @employee.update(params[:employee])
      redirect to "/employee/#{@employee.slug}"
    elsif @company && !@employee
      flash[:employee_not_registered] = "Sorry, this email address hasn't been registered. If you think this is an error, please contact #{@company.email}"
      session[:signup_id] = @company.id
      redirect to '/employee/signup'
    elsif !@company && !@employee #company hasn't registered yet and employee hasnt been created
      flash[:company_not_registered] = "Sorry, we don't have any record of the company you entered. If you'd like to register your company,"
      redirect to '/employee/signup'
    end
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

  get '/employee/delete/:id' do

    if company_logged_in?
      @employee = Employee.find_by_id(params[:id])
      erb :'employee/delete'
    else
      redirect to '/login'
    end
  end

  get '/employee/confirm-delete/:id' do
    if company_logged_in?
      @company = Company.find_by_id(session[:company_id])
      @employee = Employee.find_by_id(params[:id])
      Employee.delete(@employee)
      redirect to "/company/#{@company.slug}"
    else
      redirect to '/login'
    end
  end


end
