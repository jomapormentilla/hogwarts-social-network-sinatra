class House < ActiveRecord::Base
    has_many :wizards
    has_many :posts, through: :wizards
    
    has_one :founder, class_name: "Wizard", foreign_key: "founder_id"
    has_one :head_master, class_name: "Wizard", foreign_key: "head_master_id"

    extend Slugifiable::ClassMethods
    include Slugifiable::InstanceMethods
end