require './config/environment'

class ApplicationController < Sinatra::Base

configure do
  set :public_folder, 'public'
  set :views, 'app/views'
  enable :sessions
  set :session_secret, "thesecretofsecrets"
end

get '/' do
  erb :'home/index'
end

get '/login' do
  erb :'home/login'
end

get '/signup' do
  erb :'home/signup'
end

get '/company/signup' do
  erb :'company/signup'
end

get '/employee/signup' do
  erb :'employee/signup'
end

post '/home' do

end


end
