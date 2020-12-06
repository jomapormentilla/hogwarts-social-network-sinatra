class Post < ActiveRecord::Base
    belongs_to :wizard
    has_many :comments
    has_many :posts
end