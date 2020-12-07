class PostsController < ApplicationController
    get '/posts' do

    end

    get '/posts/:id' do
        @post = Post.find_by_id(params[:id])
        erb :'posts/show'
    end

    post '/posts/:slug/new' do
        wizard = Wizard.find_by_slug(params[:slug])

        if current_wizard.slug != wizard.slug
            flash[:message] = "Invalid User Error"
            flash[:alert_type] = "danger"
            redirect "/wizards/#{ current_wizard.slug }"
        end

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
end