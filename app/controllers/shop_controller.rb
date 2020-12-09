class ShopController < ApplicationController
    # Shop Routes
    get '/shop' do
        @wands = Wand.all
        erb :'shop/index'
    end

    # Spells Routes
    get '/spells' do
        erb :'shop/spells/index'
    end

    # Wands Routes
    get '/wands' do
        @wands = Wand.all
        erb :'shop/wands/index'
    end

    get '/wands/:slug' do
        @wand = Wand.find_by_slug(params[:slug])
        erb :'shop/wands/show'
    end
end