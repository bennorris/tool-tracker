class EmployeeController < ApplicationController

  get '/employee/signup' do #employee side
    erb :'employee/signup'
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

    if @company
        @company.employees.all.each do |employee|
          if employee.contact_info == params[:employee][:contact_info]
              @employee = employee
            end
          end
    end

    if @employee
      @employee.update(params[:employee])
    end

      if @company && @employee
        session[:employee_id] = @employee.id
        redirect to "/employee/#{@employee.slug}"
      else
        redirect to '/employee/signup'   #add different failure cases w appropriate views here
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



end
