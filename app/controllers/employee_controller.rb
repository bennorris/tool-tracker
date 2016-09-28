class EmployeeController < ApplicationController

  get '/employee/signup' do
    if !logged_in?
      erb :'employee/signup'
    else
      logged_in?
    end
  end

  get '/employee/:slug' do
    if employee_logged_in?
      @company = Company.find_by_id(@employee.company_id)
      erb :'employee/show_profile'
    elsif company_logged_in?
      redirect to "/company/#{@company.slug}"
    else
      redirect to '/login'
    end
  end

  post '/employee/new' do
    if params[:employee]
      strip_params(params[:employee])
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
    elsif @company && !@employee #company exists but hasnt added employee
      flash[:employee_not_registered] = "Sorry, this email address hasn't been registered. If you think this is an error, please contact #{@company.email}"
      redirect to '/employee/signup'
    elsif !@company && !@employee #company hasn't registered yet and employee hasnt been created
      flash[:company_not_registered] = "Sorry, we don't have any record of the company you entered. If you'd like to register your company,"
      redirect to '/employee/signup'
    end
  end

  post '/employee/edited' do

    if employee_logged_in?
      @employee.update(params[:employee])
    end
    
    redirect to "/employee/#{@employee.slug}"
  end

end
