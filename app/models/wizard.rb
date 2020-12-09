class Wizard < ActiveRecord::Base
    belongs_to :house

    has_many :wizard_spells, dependent: :destroy
    has_many :spells, through: :wizard_spells, dependent: :destroy

    has_many :wizard_friends, class_name: "WizardFriend", foreign_key: "added_friend_id", dependent: :destroy
    has_many :friends, through: :wizard_friends, dependent: :destroy
    
    has_many :wizard_added_friends, class_name: "WizardFriend", foreign_key: "friend_id", dependent: :destroy
    has_many :added_friends, through: :wizard_added_friends, dependent: :destroy
    
    has_one :wand, dependent: :destroy

    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :upvotes, dependent: :destroy

    has_secure_password

    extend Slugifiable::ClassMethods
    include Slugifiable::InstanceMethods
end