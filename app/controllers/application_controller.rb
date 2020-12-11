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

        flash[:message] = "Congratulations, #{ wizard_new.username.upcase } - You're a wizard!<br />You have been sorted in <strong>House #{ wizard_new.house.name }</strong>."
        flash[:alert_type] = "success"
        flash[:new_wizard] = "#{ wizard_new.username }"
        redirect '/login'
    end

    get '/logout' do
        redirect_if_logged_in
        redirect '/login'
    end

    post '/logout' do
        session.clear
        redirect '/login'
    end

    get '/search' do
        if params[:q]
            @houses = House.all.where("name like ?", "%#{ params[:q ]}%").includes(:wizards, :founder, :head_master)
            @wizards = Wizard.all.order(:name).where("name like ? or username like ?", "%#{ params[:q ]}%", "%#{ params[:q ]}%").includes(:friends, :added_friends, :wand, :house)
            @wands = Wand.all.where("name like ?", "%#{ params[:q ]}%").includes(:wizard)
            @spells = Spell.all.where("name like ?", "%#{ params[:q ]}%").includes(:wizards)

            @count = @wizards.size + @houses.size + @wands.size + @spells.size
        end

        if @count == 0
            flash[:message] = "No results found."
            flash[:alert_type] = "danger"
        else
            flash[:message] = "#{ @count } result#{ 's' if @count != 1 } found."
            flash[:alert_type] = "info"
        end

        erb :search
    end

    not_found do
        status 404
        erb :error
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