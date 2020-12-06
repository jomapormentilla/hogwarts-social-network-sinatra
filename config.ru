require './config/environment'

use Rack::MethodOverride
use HousesController
use WizardsController
use PostsController
use CommentsController

run ApplicationController