class Wizard < ActiveRecord::Base
    belongs_to :house

    has_many :wizard_spells
    has_many :spells, through: :wizard_spells

    has_many :wizard_friends, class_name: "WizardFriend", foreign_key: "added_friend_id"
    has_many :friends, through: :wizard_friends
    
    has_many :wizard_added_friends, class_name: "WizardFriend", foreign_key: "friend_id"
    has_many :added_friends, through: :wizard_added_friends
    
    has_one :wand

    has_many :posts
    has_many :comments
    has_many :upvotes

    has_secure_password

    before_destroy :destroy_associated_objects

    def destroy_associated_objects
        self.posts.each{ |post| post.upvotes.destroy_all }
        self.posts.destroy_all
        self.comments.destroy_all
        self.upvotes.destroy_all
    end

    extend Slugifiable::ClassMethods
    include Slugifiable::InstanceMethods
end