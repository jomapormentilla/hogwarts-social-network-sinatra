class PostsController < ApplicationController
    get '/posts' do
        
    end

    get '/posts/:id' do
        @post = Post.find_by_id(params[:id])
        erb :'posts/show'
    end

    post '/posts/:slug/new' do
        wizard = Wizard.find_by_slug(params[:slug])
        redirect_if_not_current_wizard?( wizard )

        if params[:post].values.include?("")
            flash[:message] = "All fields are required"
            flash[:alert_type] = "warning"
            redirect "/wizards/#{ current_wizard.slug }"
        end

        post = Post.new(params[:post])
        post.timestamp = Time.now
        post.wizard_id = current_wizard.id
        post.save

        flash[:message] = "Your post has been published!"
        flash[:alert_type] = "success"
        redirect "/posts/#{ post.id }"
    end

    post '/posts/:id/upvote' do
        wizard = Wizard.find_by_id(params[:id])
        redirect_if_not_current_wizard?( wizard )

        upvote = Upvote.create(wizard_id: wizard.id, post_id: params[:post][:id])
        redirect "/posts/#{ params[:post][:id] }"
    end

    get '/posts/:id/edit' do
        @post = Post.find_by_id(params[:id])
        wizard = Wizard.find_by_slug(@post.wizard.slug)
        redirect_if_not_current_wizard?( wizard )

        erb :'/posts/edit'
    end

    patch '/posts/:id' do
        post = Post.find_by_id(params[:id])
        
        if params[:post].values.include?("")
            redirect "/posts/#{ params[:id] }"
        end

        post.update(params[:post])

        redirect "/posts/#{ params[:id] }"
    end
end