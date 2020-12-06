class Upvote < ActiveRecord::Base
    belongs_to :wizard
    belongs_to :post
end