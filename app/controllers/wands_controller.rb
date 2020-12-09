class WandsController < ApplicationController
    get '/wands' do
        @wands = Wand.all
        erb :'wands/index'
    end

    get '/wands/:slug' do
        @wand = Wand.find_by_slug(params[:slug])
        erb :'wands/show'
    end
end