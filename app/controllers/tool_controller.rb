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
    erb :'tools/show_individual'
  end


end
