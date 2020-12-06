class Post < ActiveRecord::Base
    belongs_to :wizard
    has_many :comments
    has_many :posts
    has_many :upvotes

    extend Slugifiable::ClassMethods
    include Slugifiable::InstanceMethods
end