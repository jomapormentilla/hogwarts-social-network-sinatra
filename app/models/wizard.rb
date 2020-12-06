class Wizard < ActiveRecord::Base
    belongs_to :house
    has_many :spells, through: :wizard_spells
    belongs_to :friends, class_name: "Wizard", foreign_key: "friend_id"
    has_many :friends, class_name: "Wizard", foreign_key: "friend_id"
    has_one :wand
    has_many :posts
    has_many :comments
    has_many :upvotes
end