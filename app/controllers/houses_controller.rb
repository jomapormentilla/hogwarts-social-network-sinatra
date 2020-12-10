class HousesController < ApplicationController

    get '/houses' do
        @houses = House.all.includes(:wizards, :founder, :head_master)
        @posts = Post.order(timestamp: :desc).limit(10).includes(:wizard, :comments, :upvotes)
        erb :'houses/index'
    end

    get '/houses/:slug' do
        @houses = House.all
        @house = House.includes(:wizards, :posts).find_by_slug(params[:slug])
        @wizards = @house.wizards.order(:name)
        @posts = @house.posts.order(timestamp: :desc).includes(:wizard, :upvotes, :comments)
        erb:'houses/show'
    end
    
end