class CommentsController < ApplicationController
    
    get '/comments' do
        redirect '/houses'
    end

    get '/comments/:id' do
        redirect "/wizards/#{ current_wizard.slug }"
    end

    post '/comments/:id' do
        post = Post.find_by_id(params[:id])

        redirect_if_obj_not_found( post )
        redirect_if_form_empty( params )

        data = {
            content: params[:content],
            timestamp: Time.now,
            wizard_id: current_wizard.id,
            post_id: post.id
        }

        Comment.create(data)

        redirect "/posts/#{ post.id }"
    end

    delete '/comments/:id' do
        comment = Comment.find_by_id(params[:id])
        redirect_if_not_current_wizard( comment.wizard )

        comment.delete

        redirect_to_previous_page( request )
    end
    
end