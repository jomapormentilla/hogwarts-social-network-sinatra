class House < ActiveRecord::Base
    has_many :wizards
    has_many :posts, through: :wizards
end