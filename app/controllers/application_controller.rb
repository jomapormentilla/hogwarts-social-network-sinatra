require 'rack-flash'

class ApplicationController < Sinatra::Base
    use Rack::Flash

    configure do
        enable :sessions
        set :session_secret, 'mysupersecretpassword'
        set :public_dir, 'public'
        set :views, 'app/views'
    end

    get '/' do
        erb :index
    end
end