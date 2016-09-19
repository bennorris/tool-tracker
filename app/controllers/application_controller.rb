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

end

get '/employee/signup' do

end

post '/home' do

end


end
