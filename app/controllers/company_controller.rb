class CompanyController < ApplicationController

  get '/company/signup' do
    erb :'company/signup'
  end

  get '/company/:slug' do

    @company = Company.find_by_id(session[:company_id])

    if company_logged_in? && @company.slug == params[:slug]
      erb :'company/show'
    elsif company_logged_in?
      redirect to "/company/#{@company.slug}"
    else
      redirect to '/login'
    end
  end

  post '/company' do

      if params[:company][:name].empty? || params[:company][:contact_name].empty? || params[:company][:email].empty? || params[:company][:password].empty?
        redirect to '/company/signup'
      elsif params[:company][:password] != params[:password_confirmation]
        redirect to '/company/signup'
      end
      @company = Company.new(params[:company])
      @company.save
      session[:company_id] = @company.id

      redirect to "/company/#{@company.slug}"
  end

end
