class HousesController < ApplicationController
    get '/houses' do
        @houses = House.all.includes(:wizards, :founder, :head_master)
        @posts = Post.order(timestamp: :desc).limit(10).includes(:wizard, :comments, :upvotes)
        erb :'houses/index'
    end

    get '/houses/:slug' do
        @house = House.find_by_slug(params[:slug])
        erb:'houses/show'
    end

    get '/houses/:slug/wizards' do

    end
end