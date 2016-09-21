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

    if company_logged_in? && @tool.company_id == @company.id
      erb :'tools/show_individual'
    elsif company_logged_in?
      redirect to "/company/#{@company.slug}"
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
    @tool.update(params[:tool])
    @company = Company.find_by_id(session[:company_id])

    if params[:available] && !params[:employee_name]
      @tool.available = true
      Employee.all.each do |employee|
        if employee.tools.include?(@tool)
            @employee = employee
          end
      end
      @employee.tools.delete(@tool)
      @employee.save
      @tool.save
    elsif !params[:available] && !params[:not_available]
      redirect to "/tools/#{@tool.slug}/error-3"
    elsif params[:available] && params[:employee_name]
        redirect to "/tools/#{@tool.slug}/error-1"
    elsif !params[:not_available].empty? && !params[:employee_name]
        redirect to "/tools/#{@tool.slug}/error-2"
    elsif params[:not_available]

      @tool.available = false
      @employee = Employee.find_by(first_name: params[:employee_name].split(" ")[0], last_name: params[:employee_name].split(" ")[1])
      @employee.tools << @tool
      @tool.save
      @employee.save
    end

    redirect to "/company/#{@company.slug}"
  end


end
