class WizardsController < ApplicationController
    get '/wizards' do
        @wizards = Wizard.all
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
        redirect "/wizards/#{ wizard.slug }"
    end

    get '/wizards/:slug/edit' do
        @wizard = Wizard.find_by_slug(params[:slug])
        erb :'/wizards/edit'
    end
end