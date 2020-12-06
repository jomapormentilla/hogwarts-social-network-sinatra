class WizardsController < ApplicationController
    get '/wizards' do
        @wizards = Wizard.all
        erb :'wizards/index'
    end

    get '/wizards/:slug' do
        @wizard = Wizard.find_by_slug(params[:slug])
        erb :'wizards/show'
    end
end