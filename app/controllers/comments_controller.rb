class CommentsController < ApplicationController
    get '/' do
        redirect '/houses'
    end

    post '/comments/:id/new' do
        post = Post.find_by_id(params[:id])

        if params.values.include?("")
            flash[:comment_message] = "Error: Please provide content for your comment."
            flash[:alert_type] = "warning"

            redirect "/posts/#{ post.id }"
        end

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