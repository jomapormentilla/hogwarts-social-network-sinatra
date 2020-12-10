class Spell < ActiveRecord::Base
    has_many :wizard_spells
    has_many :wizards, through: :wizard_spells

    extend Slugifiable::ClassMethods
    include Slugifiable::InstanceMethods
end