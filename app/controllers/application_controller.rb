require './config/environment'

class ApplicationController < Sinatra::Base

configure do
  set :public_folder, 'public'
  set :views, 'app/views'
  enable :sessions
  set :session_secret, "thesecretofsecrets"
end

helpers do
   def company_logged_in?
     if session[:company_id]
       true
     else
       false
     end
   end

   def employee_logged_in?
     if session[:employee_id]
       true
     else
       false
     end
   end

 end

get '/' do
  @company = Company.find_by_id(session[:company_id])   #need better solution here in case ID matches both
  @employee = Employee.find_by_id(session[:employee_id])

  if company_logged_in?
      redirect to "/company/#{@company.slug}"
  elsif employee_logged_in?
      redirect to "/employee/#{@employee.slug}"
  else
    erb :'home/index'
  end
end

get '/login' do
  @company = Company.find_by_id(session[:company_id])
  @employee = Employee.find_by_id(session[:employee_id])

  if company_logged_in?
      redirect to "/company/#{@company.slug}"
  elsif employee_logged_in?
      redirect to "/employee/#{@employee.slug}"
  else
    erb :'home/login'
  end
end

get '/signup' do
  @company = Company.find_by_id(session[:company_id])
  @employee = Employee.find_by_id(session[:employee_id])

  if company_logged_in?
      redirect to "/company/#{@company.slug}"
  elsif employee_logged_in?
      redirect to "/employee/#{@employee.slug}"
  else
    erb :'home/signup'
  end
end

post '/home' do
  @employee = Employee.find_by(contact_info: params[:user][:username])
  @company = Company.find_by(email: params[:user][:username])


  if @employee && @employee.authenticate(params[:user][:password])
      session[:employee_id] = @employee.id
      redirect to "/employee/#{@employee.slug}"
  elsif @company && @company.authenticate(params[:user][:password])
      session[:company_id] = @company.id
      redirect to "/company/#{@company.slug}"
  else
    redirect to '/login/failed'
  end
end

get '/login/failed' do
  if company_logged_in?
      redirect to "/company/#{@company.slug}"
  elsif employee_logged_in?
      redirect to "/employee/#{@employee.slug}"
  else
    erb :'home/login_failed'
  end
end

get '/logout' do
  session.clear
  redirect to '/login'
end


end
