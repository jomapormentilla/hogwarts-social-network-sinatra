class WizardsController < ApplicationController
   
    get '/wizards' do
        if params[:search_term]
            @wizards = Wizard.all.order(:name).includes(:house, :wand, :friends, :added_friends).where("#{ params[:type] } like ?", "%#{ params[:search_term ]}%")
            if @wizards.empty?
                flash[:message] = "No wizards found."
                flash[:alert_type] = "danger"
                redirect "/wizards"
            end
        else
            @wizards = Wizard.all.order(:name).includes(:house, :wand, :friends, :added_friends)
        end
        
        erb :'wizards/index'
    end

    get '/wizards/:slug' do
        @wizard = Wizard.includes(:posts, :upvotes, :house, :wand, :friends, :added_friends).find_by_slug(params[:slug])
        redirect_if_obj_not_found( @wizard )
            
        @all_friends = []
        @wizard.friends.each{ |friend| @all_friends << friend }
        @wizard.added_friends.each{ |friend| @all_friends << friend }

        @posts = @wizard.posts.order(timestamp: :desc).limit(20).includes(:comments, :upvotes, :wizard)
        @upvotes = @wizard.upvotes.order(id: :desc).limit(10).includes(:post)

        erb :'wizards/show'
    end

    post '/wizards/:slug/add_friend' do
        wizard = Wizard.find_by_slug(params[:slug])

        if wizard == nil
            flash[:message] = "Error: Wizard not found."
            flash[:alert_type] = "danger"
            redirect_to_previous_page( request )
        end

        if wizard == current_wizard
            flash[:message] = "Error: Attempt to add yourself to your Friends List has failed."
            flash[:alert_type] = "danger"
            redirect_to_previous_page( request )
        end

        if wizard.added_friends.include?(current_wizard)
            flash[:message] = "Error: Attempt to add #{ wizard.name } failed."
            flash[:alert_type] = "danger"
            redirect_to_previous_page( request )
        end

        current_wizard.friends << wizard

        flash[:message] = "You are now friends with #{ wizard.name }!"
        flash[:alert_type] = "success"
        redirect_to_previous_page( request )
    end

    post '/wizards/:slug/remove_friend' do
        wizard = Wizard.find_by_slug(params[:slug])

        if wizard == nil
            flash[:message] = "Error: Wizard not found."
            flash[:alert_type] = "danger"
            redirect_to_previous_page( request )
        end

        if wizard == current_wizard
            flash[:message] = "Error: Attempt to unfriend yourself failed."
            flash[:alert_type] = "danger"
            redirect_to_previous_page( request )
        end

        if !current_wizard.friends.include?(wizard)
            flash[:message] = "Error: Attempt to unfriend #{ wizard.name } failed."
            flash[:alert_type] = "danger"
            redirect_to_previous_page( request )
        end

        current_wizard.friends.delete(wizard.id)

        flash[:message] = "You are no longer friends with #{ wizard.name }!"
        flash[:alert_type] = "danger"
        redirect_to_previous_page( request )
    end

    get '/wizards/:slug/edit' do
        @wizard = Wizard.find_by_slug(params[:slug])
        redirect_if_not_current_wizard( @wizard )

        erb :'/wizards/edit'
    end

    patch '/wizards/edit' do
        wizard = Wizard.find_by_username(params[:wizard][:username])

        if wizard && wizard.username != current_wizard.username
            flash[:message] = "Error: The username <b>#{ params[:wizard][:username] }</b> is already taken."
            flash[:alert_type] = "warning"
            redirect_to_previous_page( request )
        end

        new_name = "#{ params[:wizard][:fname] } #{ params[:wizard][:lname] }"

        data = {
            username: params[:wizard][:username],
            name: new_name,
            email: params[:wizard][:email]
        }

        current_wizard.update(data)

        flash[:message] = "Successfully updated your profile."
        flash[:alert_type] = "success"
        redirect "/wizards/#{ current_wizard.slug }"
    end

    delete '/wizards/:slug/delete' do
        wizard = Wizard.find_by_slug(params[:slug])
        redirect_if_not_current_wizard( wizard )

        session.clear
        Wizard.destroy(wizard.id)

        flash[:message] = "Your account has been deleted."
        flash[:alert_type] = "danger"
        redirect '/'
    end

    private

    def is_founder?( wizard )
        wizard.house.founder == wizard
    end

    def is_head_master?( wizard )
        wizard.house.head_master == wizard
    end
    
end