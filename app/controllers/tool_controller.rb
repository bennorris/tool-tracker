class ToolController < ApplicationController

  post '/tools/new' do
    @tool = Tool.new(params[:tool])
    @company = Company.find_by(name: params[:company_name])
    @company.tools << @tool
    @company.save
    @tool.save

    redirect to "/company/#{@company.slug}"
  end

  get '/tools/:slug' do
    @company = Company.find_by_id(session[:company_id])
    @tool = Tool.find_by(product: params[:slug].gsub("-", " "))
    @employee = Employee.find_by_id(session[:employee_id])

    if company_logged_in? && @tool.company_id == @company.id
      erb :'tools/show_individual'
    elsif employee_logged_in? && @employee.company_id == @tool.company_id
      erb :'tools/show_individual_for_employee'
    elsif company_logged_in?
      redirect to "/company/#{@company.slug}"
    elsif employee_logged_in?
      redirect to "/employee/#{@employee.slug}"
    else
      redirect to '/login'
    end
  end

  post '/tools' do

    @tool = Tool.find_by_id(params[:tool_id])
    @company = Company.find_by_id(session[:company_id])

    if params[:available] && !params[:employee] && !params[:not_available]
      @tool.available = true
      @tool.employees.clear
      @tool.update(params[:tool])
    elsif !params[:available] && !params[:not_available] #no answer to available
      flash[:no_selection] = "Please select either 'Yes' or 'No' to 'Is it Available?'"
      redirect to "/tools/#{@tool.slug}"
    elsif params[:available] && params[:not_available] #yes and no to available
      flash[:yes_and_no] = "Please select either 'Yes' or 'No', not both."
      redirect to "/tools/#{@tool.slug}"
    elsif params[:available] && params[:employee] #available but assigned to employee
      flash[:error_1] = "The tool cannot be available and assigned to an employee at the same time. If you select 'Yes' to 'Is it available?', please uncheck all employees."
      redirect to "/tools/#{@tool.slug}"
    elsif !params[:not_available].empty? && !params[:employee] #selected not avail but didn't assign employee
      flash[:error_2] = "The tool cannot be checked out unless it is assigned to an employee. If you select 'no' to 'Is it Available?', please select an employee too."
      redirect to "/tools/#{@tool.slug}"
    elsif params[:not_available]
      @tool.employees.clear
      @tool.available = false
      @tool.update(params[:tool])

      params[:employee].each do |key, value|
        @employee = Employee.find_by(first_name: value.split(" ")[0], last_name: value.split(" ")[1])
        @tool.employees << @employee
      end
      @tool.save
    end

    redirect to "/company/#{@company.slug}"
  end

  post '/tools/edited' do
    @tool = Tool.find_by(params[:tool_id])
    @employee = Employee.find_by_id(session[:employee_id])

    if params[:not_available] && params[:available]
      erb :'tools/tools_error_five'
    elsif params[:not_available] && @employee.tools.include?(@tool)
      erb :'tools/tools_error_four'
    elsif params[:not_available] && !@employee.tools.include?(@tool)#checking out the tool
      @tool.available = false
      @employee.tools << @tool
      @tool.update(params[:tool])
      redirect to "/employee/#{@employee.slug}"
    elsif params[:available] && @tool.employees.include?(@employee) #returning the tool
      @tool.available = true
      @employee.tools.delete(@tool)
      @tool.update(params[:tool])
      redirect to "/employee/#{@employee.slug}"
    end
  end

  post '/tools/admin-edited' do
    @employee = Employee.find_by_id(params[:employee])
    @company = Company.find_by_id(session[:company_id])

    params[:tool].each do |key, value|
      @tool = Tool.find_by_id(value)
      @employee.tools.delete(@tool)
        if @tool.employees.empty?
          @tool.available = true
          @tool.save
        end
    end
    
    redirect to "/company/#{@company.slug}"
  end

  get '/tools/delete/:id' do
    if company_logged_in?
      @tool = Tool.find_by_id(params[:id])
      erb :'tools/delete'
    else
      redirect to '/login'
    end
  end

  get '/tools/confirm-delete/:id' do
    if company_logged_in?
      @company = Company.find_by_id(session[:company_id])
      @tool = Tool.find_by_id(params[:id])
      Tool.delete(@tool)
      redirect to "/company/#{@company.slug}"
    else
      redirect to '/login'
    end
  end


end
