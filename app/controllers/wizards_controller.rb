class WizardsController < ApplicationController
    get '/wizards' do
        @wizards = Wizard.all.order(:name)
        erb :'wizards/index'
    end

    get '/wizards/:slug' do
        @wizard = Wizard.find_by_slug(params[:slug])

        @all_friends = []
        @wizard.friends.uniq.each{ |friend| @all_friends << friend }
        @wizard.added_friends.uniq.each{ |friend| @all_friends << friend }

        erb :'wizards/show'
    end

    post '/wizards/:slug/add_friend' do
        wizard = Wizard.find_by_slug(params[:slug])
        current_wizard.friends << wizard

        flash[:message] = "You are now friends with #{ wizard.name }!"
        flash[:alert_type] = "success"
        redirect_to_previous_page( request )
    end

    post '/wizards/:slug/remove_friend' do
        wizard = Wizard.find_by_slug(params[:slug])
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
        new_name = "#{ params[:fname] } #{ params[:lname] }"

        data = {
            username: params[:wizard][:username],
            name: new_name,
            email: params[:wizard][:email]
        }

        current_wizard.update(data)

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