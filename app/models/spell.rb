class Spell < ActiveRecord::Base
    has_many :wizards, through: :wizard_spells
end