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
        redirect_if_logged_in
        erb :index
    end

    post '/' do
        wizard = Wizard.find_by_username(params[:username])

        if wizard && wizard.authenticate(params[:password])
            session[:wizard_id] = wizard.id
            redirect '/houses'
        end

        flash[:message] = "Invalid Credentials"
        flash[:alert_type] = "warning"
        redirect '/'
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

        flash[:message] = "Congratulations, #{ wizard_new.username.upcase } - You're a wizard!"
        flash[:alert_type] = "success"
        redirect '/'
    end

    helpers do
        def current_wizard
            @current_wizard ||= Wizard.find(session[:wizard_id]) if session[:wizard_id]
        end
        
        def logged_in?
            !!session[:wizard_id]
        end
    end

    private

    def redirect_if_logged_in
        if logged_in?
            redirect '/houses'
        end
    end
end