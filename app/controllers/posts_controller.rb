class PostsController < ApplicationController
    get '/posts' do
        redirect '/houses'
    end

    get '/posts/:id' do
        @post = Post.includes(:wizard, :upvotes).find_by_id(params[:id])
        redirect_if_obj_not_found( @post )

        erb :'posts/show'
    end

    post '/posts' do
        redirect_if_form_empty( params[:post] )

        post = Post.new(params[:post])
        post.timestamp = Time.now
        post.wizard_id = current_wizard.id
        post.save

        flash[:message] = "Your post has been published!"
        flash[:alert_type] = "success"
        redirect_to_previous_page( request )
    end

    post '/posts/:id/upvote' do
        post = Post.find_by_id(params[:id])
        redirect_if_obj_not_found( post )

        if post.upvotes.any?{|upvote| upvote.wizard == current_wizard }
            flash[:message] = "Error: Post already upvoted."
            flash[:alert_type] = "danger"
            redirect_to_previous_page( request )
        end

        upvote = Upvote.create(wizard_id: current_wizard.id, post_id: params[:id])
        redirect_to_previous_page( request )
    end

    get '/posts/:id/edit' do
        @post = Post.find_by_id(params[:id])
        redirect_if_obj_not_found( @post )

        wizard = Wizard.find_by_slug(@post.wizard.slug)
        redirect_if_not_current_wizard( wizard )

        erb :'/posts/edit'
    end

    patch '/posts/:id' do
        redirect_if_form_empty( params[:post] )

        post = Post.find_by_id(params[:id])
        redirect_if_obj_not_found( post )

        wizard = Wizard.find_by_slug(post.wizard.slug)
        redirect_if_not_current_wizard( wizard )

        post.update(params[:post])

        redirect "/posts/#{ post.id }"
    end

    delete '/posts/:id' do
        post = Post.find_by_id(params[:id])
        redirect_if_obj_not_found( post )

        wizard = Wizard.find_by_slug(post.wizard.slug)
        redirect_if_not_current_wizard( wizard )

        post.delete

        flash[:message] = "Post deleted!"
        flash[:alert_type] = "info"
        redirect "/wizards/#{ current_wizard.slug }"
    end
end