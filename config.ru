require './config/environment'

use Rack::MethodOverride

use HousesController
use WizardsController
use PostsController
use CommentsController
use SpellsController
use WandsController
use ShopController

run ApplicationController