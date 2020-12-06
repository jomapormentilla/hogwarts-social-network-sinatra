class House < ActiveRecord::Base
    has_many :wizards
    has_many :posts, through: :wizards

    extend Slugifiable::ClassMethods
    include Slugifiable::InstanceMethods
end