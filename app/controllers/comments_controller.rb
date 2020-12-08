class CommentsController < ApplicationController
    get '/' do
        redirect '/houses'
    end

    post '/comments/:id/new' do
        post = Post.find_by_id(params[:id])

        data = {
            content: params[:content],
            timestamp: Time.now,
            wizard_id: current_wizard.id,
            post_id: post.id
        }

        Comment.create(data)

        redirect "/posts/#{ post.id }"
    end
end