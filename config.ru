require './config/environment'
require_all 'app'

use CompanyController
use ToolController
use EmployeeController
run ApplicationController
