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

        redirect_if_form_empty( params[:wizard] )

        if params[:wizard][:username].split.any?{ |char| char =~ /\W/ }
            flash[:message] = "Error: Username <b>#{ params[:wizard][:username] }</b> contains invalid characters."
            flash[:alert_type] = "danger"
            redirect '/signup'
        end

        if valid_email_regex?(params[:wizard][:email])
            flash[:message] = "Error: Email Address <b>#{ params[:wizard][:email] }</b> contains invalid characters."
            flash[:alert_type] = "danger"
            redirect '/signup'
        end

        if wizard || wizard_email
            flash[:message] = "Error: Username or Email is already registered."
            flash[:alert_type] = "danger"
            redirect '/signup'
        end

        if params[:wizard][:password] != params[:confirm]
            flash[:message] = "Error: Confirm Password does not match."
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
        session.clear
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

        def valid_email_regex?( string )
            # General Email Regex (RFC 5322 Official Standard)
            string.match(/(?:[a-z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/)
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
            flash[:message] = "Error: Page Not Found."
            flash[:alert_type] = "danger"
            redirect "/wizards/#{ current_wizard.slug }"
        end
    end

    def redirect_to_previous_page( request_obj )
        origin = request_obj.env["HTTP_ORIGIN"]
        path = request_obj.env["HTTP_REFERER"].gsub(origin,"")

        redirect "#{ path }"
    end
end