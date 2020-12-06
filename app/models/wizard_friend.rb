class WizardFriend < ActiveRecord::Base
    belongs_to :friend, class_name: "Wizard"
    belongs_to :added_friend, class_name: "Wizard"
end