require './config/environment'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use Rack::Session::Cookie, :secret => ENV['SESSION_KEY'] || 'thesecretofsecrets'

use CompanyController
use ToolController
use EmployeeController
run ApplicationController
