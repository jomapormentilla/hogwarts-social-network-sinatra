class Wand < ActiveRecord::Base
    belongs_to :wizard

    extend Slugifiable::ClassMethods
    include Slugifiable::InstanceMethods
end