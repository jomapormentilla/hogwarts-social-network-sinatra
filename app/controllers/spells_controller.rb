class SpellsController < ApplicationController
    
    get '/spells' do
        @spells = Spell.all.includes(:wizard).order(price: :desc)
        erb :'shop/spells/index'
    end

    get '/spells/:slug' do
        @spell = Spell.find_by_slug(params[:slug])
        redirect_if_obj_not_found( @spell )

        erb :'shop/spells/show'
    end

    post '/spells' do

    end

    get '/spells/:slug/edit' do

    end
end