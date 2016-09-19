class CompanyController < ApplicationController

  get '/company/signup' do
    erb :'company/signup'
  end

  get '/company/:slug' do
    @company = Company.find_by(name: params[:slug].gsub("-", " "))
    erb :'company/show'
  end

  post '/company' do
    if params[:company][:name].empty? || params[:company][:contact_name].empty? || params[:company][:email].empty? || params[:company][:password].empty?
      redirect to '/company/signup'
    elsif params[:company][:password] != params[:password_confirmation]
      redirect to '/company/signup'
    end
    @company = Company.new(params[:company])
    @company.save

    redirect to "/company/#{@company.slug}"
  end

end
