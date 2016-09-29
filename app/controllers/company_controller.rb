class CompanyController < ApplicationController

  helpers do
    def email_exists?
      Company.find_by(email: params[:company][:email])
    end

    def company_exists?
      Company.find_by(name: params[:company][:name])
    end
  end

  get '/company/signup' do
    if !logged_in?
      erb :'company/signup'
    else
      logged_in?
    end
  end

  get '/company/:slug' do
    if company_logged_in? && @company.slug == params[:slug]
      @available_tools = @company.tools.where(available: true)
      @unavailable_tools = @company.tools.where(available: false)
      @all_tools = @company.tools
      erb :'company/show'
    else
      redirect to '/login'
    end
  end

  post '/company' do
    flash[:co_success] = "Success! Thanks for signing up!"
    if !params[:company][:email].include?("@") || !params[:company][:email].include?(".")
      flash[:email_fail] = "Please enter a valid email address."
      redirect to '/company/signup'
    elsif params[:company][:password] != params[:password_confirmation]
      flash[:password_fail] = "Please enter matching passwords."
      redirect to '/company/signup'
    elsif email_exists?
      flash[:email_exists] = "This email address has already been registered."
      redirect to '/company/signup'
    elsif company_exists?
      flash[:company_exists] = "This company has already been registered."
      redirect to '/company/signup'
    else
      @company = Company.new(params[:company])
        if !@company.save
          flash[:empty_fields] = "Please fill out every field."
          redirect to '/company/signup'
        else
          @company.save
          session[:company_id] = @company.id
          redirect to "/company/#{@company.slug}"
        end
      end
  end

  get '/delete-company-account' do
    if company_logged_in?
      erb :'company/delete'
    else
      redirect to '/login'
    end
  end

    get '/delete-company' do
      if company_logged_in?
        Company.delete(@company)
        flash[:account_deleted] = "Your account has been deleted."
        redirect to '/'
      else
        redirect to '/login'
      end
    end

  end
