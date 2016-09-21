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
    @tool = Tool.find_by(product: params[:slug].gsub("-", " "))
    @company = Company.find_by_id(session[:user_id])
    erb :'tools/show_individual'
  end

  post '/tools' do

    @tool = Tool.find_by_id(params[:tool_id])
    @tool.update(params[:tool])
    @company = Company.find_by_id(session[:user_id])

    if params[:available]
      @tool.available = true
      Employee.all.each do |employee|
        if employee.tools.include?(@tool)
            @employee = employee
          end
      end
      @employee.tools.delete(@tool)
      @employee.save
      @tool.save

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
