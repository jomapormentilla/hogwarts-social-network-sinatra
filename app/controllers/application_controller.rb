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
        redirect '/login'
    end

    get '/login' do
        redirect_if_logged_in
        erb :index
    end

    post '/login' do
        wizard = Wizard.find_by_username(params[:username])

        if wizard && wizard.authenticate(params[:password])
            session[:wizard_id] = wizard.id
            redirect '/houses'
        end

        flash[:message] = "Invalid Credentials"
        flash[:alert_type] = "warning"
        redirect '/login'
    end

    get '/signup' do
        redirect_if_logged_in
        erb :signup
    end

    post '/signup' do
        wizard = Wizard.find_by_username(params[:wizard][:username])
        wizard_email = Wizard.find_by_email(params[:wizard][:email])

        if params[:wizard].values.include?("")
            flash[:message] = "All fields are required."
            flash[:alert_type] = "danger"
            redirect '/signup'
        end

        if params[:wizard][:username].split.any?{ |char| char =~ /\W/ }
            flash[:message] = "Username contains invalid characters."
            flash[:alert_type] = "danger"
            redirect '/signup'
        end

        if wizard || wizard_email
            flash[:message] = "Username or Email is already registered."
            flash[:alert_type] = "danger"
            redirect '/signup'
        end

        if params[:wizard][:password] != params[:confirm]
            flash[:message] = "Confirm Password does not match."
            flash[:alert_type] = "warning"
            redirect '/signup'
        end

        wizard_new = Wizard.create(params[:wizard])
        
        wizard_new.name = "#{ params[:fname] } #{ params[:lname] }"
        wizard_new.house = House.all.sample
        wizard_new.balance = 1000
        wizard_new.save

        flash[:message] = "Congratulations, #{ wizard_new.username.upcase } - You're a wizard!"
        flash[:alert_type] = "success"
        flash[:new_wizard] = "#{ wizard_new.username }"
        redirect '/login'
    end

    get '/shop' do
        @wands = Wand.all
        erb :'shop/index'
    end

    get '/logout' do
        redirect_if_logged_in
        redirect '/login'
    end

    post '/logout' do
        session.clear
        redirect '/login'
    end

    helpers do
        def current_wizard
            @current_wizard ||= Wizard.find(session[:wizard_id]) if session[:wizard_id]
        end
        
        def logged_in?
            !!session[:wizard_id]
        end

        def is_current_session?( obj )
            obj.id == current_wizard.id
        end

        def parse_timestamp( time )
            _time = time.in_time_zone('Eastern Time (US & Canada)')
            _time.strftime("%B %d, %Y, %l:%M%P")
        end
    end

    private

    def redirect_if_logged_in
        if logged_in?
            redirect "/wizards/#{ current_wizard.slug }"
        end
    end

    def redirect_if_not_current_wizard( wizard )
        if current_wizard.slug != wizard.slug
            flash[:message] = "Invalid User Error"
            flash[:alert_type] = "danger"
            redirect "/wizards/#{ current_wizard.slug }"
        end
    end

    def redirect_if_form_empty( params_obj )
        if params_obj.values.include?("")
            flash[:message] = "Error: Text field cannot be blank."
            flash[:alert_type] = "danger"

            redirect_to_previous_page( request )
        end
    end

    def redirect_if_obj_not_found( obj )
        if obj == nil
            flash[:message] = "Error: Unable to find post."
            flash[:alert_type] = "warning"
            redirect_to_previous_page
        end
    end

    def redirect_to_previous_page( request_obj )
        origin = request_obj.env["HTTP_ORIGIN"]
        path = request_obj.env["HTTP_REFERER"].gsub(origin,"")

        redirect "#{ path }"
    end
end