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

  get '/tools/:slug/error-1' do
    @tool = Tool.find_by(product: params[:slug].gsub("-", " "))
    @company = Company.find_by_id(session[:company_id])

    if company_logged_in? && @tool.company_id == @company.id
      erb :'tools/show_individual_error_one'
    elsif company_logged_in?
      redirect to "/company/#{@company.slug}"
    else
      redirect to '/login'
    end
  end

  get '/tools/:slug/error-2' do
    @tool = Tool.find_by(product: params[:slug].gsub("-", " "))
    @company = Company.find_by_id(session[:company_id])

    if company_logged_in? && @tool.company_id == @company.id
      erb :'tools/show_individual_error_two'
    elsif company_logged_in?
      redirect to "/company/#{@company.slug}"
    else
      redirect to '/login'
    end
  end

  get '/tools/:slug/error-3' do
    @tool = Tool.find_by(product: params[:slug].gsub("-", " "))
    @company = Company.find_by_id(session[:company_id])

    if company_logged_in? && @tool.company_id == @company.id
      erb :'tools/show_individual_error_three'
    elsif company_logged_in?
      redirect to "/company/#{@company.slug}"
    else
      redirect to '/login'
    end
  end

  post '/tools' do

    @tool = Tool.find_by_id(params[:tool_id])
    @company = Company.find_by_id(session[:company_id])
    binding.pry

    if params[:available] && !params[:employee_name]
      @tool.available = true
      @tool.employees.clear
      @tool.update(params[:tool])
    elsif !params[:available] && !params[:not_available] #no answer to available
      redirect to "/tools/#{@tool.slug}/error-3"
    elsif params[:available] && params[:employee_name] #available but assigned to employee
        redirect to "/tools/#{@tool.slug}/error-1"
    elsif !params[:not_available].empty? && !params[:employee_name] #selected not avail but didn't assign employee
        redirect to "/tools/#{@tool.slug}/error-2"
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


end
