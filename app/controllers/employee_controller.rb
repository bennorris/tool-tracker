class EmployeeController < ApplicationController

  post '/employee/new' do
    @employee = Employee.new(params[:employee])
    @company = Company.find_by(name: params[:company])
    @company.employees << @employee
    @company.save
    @employee.save

    redirect to "/company/#{@company.slug}"
  end

end
