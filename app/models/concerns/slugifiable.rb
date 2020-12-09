module Slugifiable
    module ClassMethods
        def find_by_slug( slug )
            result = self.all.detect{ |obj| obj.slug == slug }
        end
    end

    module InstanceMethods
        def slug
            string = self.class == Wizard ? self.username : self.name
            string.downcase.gsub(/\W/," ").gsub(/\s+/," ").gsub(" ","-")
        end
    end
end