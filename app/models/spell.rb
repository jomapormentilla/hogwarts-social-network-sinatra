class Spell < ActiveRecord::Base
    has_many :wizard_spells
    has_many :wizards, through: :wizard_spells

    extend Slugifiable::ClassMethods
    include Slugifiable::InstanceMethods

    def self.includes_custom( params )
        self.includes(:wizards).order(:name => 'asc').where("#{ params[:type] } like ?", "%#{ params[:search_term] }%")
    end
end