class PostsController < ApplicationController
    get '/posts' do

    end

    get '/posts/:id' do
        @post = Post.find_by_id(params[:id])
        erb :'posts/show'
    end
end