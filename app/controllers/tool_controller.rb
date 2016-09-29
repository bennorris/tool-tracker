class ToolController < ApplicationController

  post '/tools/new' do  #admin creating tool
    if company_logged_in?
      @company.tools.create(params[:tool])
      redirect to "/company/#{@company.slug}"
    else
      redirect to '/login'
    end
  end

  get '/tools/:slug' do
    @tool = Tool.find_by(product: params[:slug].gsub("-", " "))
    if company_logged_in? && @tool.company_id == @company.id
      @company_employees = @company.employees
      erb :'tools/show_individual'
    elsif employee_logged_in? && @employee.company_id == @tool.company_id
      erb :'tools/show_individual_for_employee'
    else
      redirect to '/login'
    end
  end

  post '/tools' do #admin editing tool
    @tool = Tool.find_by_id(params[:tool_id])
    if company_logged_in? && @tool.company_id == @company.id
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
        @tool.employee_ids = params[:employee][:employee_ids]
      end
        @tool.save
    end
    redirect to "/company/#{@company.slug}"
  end

  post '/tools/edited' do  #employee editing tool
    @tool = Tool.find_by(params[:tool_id])
    if employee_logged_in?
      if params[:not_available] && params[:available]
        flash[:selected_both] = "Oops, you submitted 'Yes' to both 'checking out' and 'returning.' Please select one."
        redirect to "tools/#{@tool.slug}"
      elsif params[:not_available] && @employee.tools.include?(@tool)
        flash[:already_out] = "Oops, you tried to check out a product that you've already checked out."
        redirect to "tools/#{@tool.slug}"
      elsif params[:available] && !@employee.tools.include?(@tool)
        flash[:not_yours] = "Sorry, you can't return a tool that you haven't checked out."
        redirect to "tools/#{@tool.slug}"
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

  post '/tools/admin-edited' do  #admin editing tool from employee info page
    @employee = Employee.find_by_id(params[:employee])
    if company_logged_in?
      params[:tool].each do |key, value|
        @tool = Tool.find_by_id(value)
        @employee.tools.delete(@tool)
          if @tool.employees.empty?
            @tool.available = true
            @tool.save
          end
      end
    end
    redirect to "/company/#{@company.slug}"
  end

  get '/tools/delete/:id' do
    @tool = Tool.find_by_id(params[:id])
    if company_logged_in? && @company.tools.include?(@tool)
      erb :'tools/delete'
    else
      redirect to '/login'
    end
  end

  get '/tools/confirm-delete/:id' do
    @tool = Tool.find_by_id(params[:id])
    if company_logged_in? && @company.tools.include?(@tool)
      Tool.delete(@tool)
      redirect to "/company/#{@company.slug}"
    else
      redirect to '/login'
    end
  end

end
