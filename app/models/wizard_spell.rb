class WizardSpell < ActiveRecord::Base
    belongs_to :wizard
    belongs_to :spell
end