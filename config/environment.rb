ENV['SINATRA_ENV'] ||= "development"
require 'bundler/setup'
require_all 'app'

Bundler.require(:default, ENV['SINATRA_ENV'])

configure :development do
ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
)
end

configure :production do
 db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///localhost/mydb')

 ActiveRecord::Base.establish_connection(
   :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
   :host     => db.host,
   :username => db.user,
   :password => db.password,
   :database => db.path[1..-1],
   :encoding => 'utf8'
 )
end


# # ENV['SINATRA_ENV'] ||= "development"
# #
# # require 'bundler/setup'
# # Bundler.require(:default, ENV['SINATRA_ENV'])
# #
# # # ActiveRecord::Base.establish_connection(
# # #   :adapter => "sqlite3",
# # #   :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
# # # )
#
# configure :development do
#  set :database, 'sqlite:///dev.db'
#  set :show_exceptions, true
# end
#
# configure :production do
#  db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///localhost/mydb')
#
#  ActiveRecord::Base.establish_connection(
#    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
#    :host     => db.host,
#    :username => db.user,
#    :password => db.password,
#    :database => db.path[1..-1],
#    :encoding => 'utf8'
#  )
# end
#
# require_all 'app'
