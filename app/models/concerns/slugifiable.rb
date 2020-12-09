module Slugifiable
    module ClassMethods
        def find_by_slug( slug )
            result = []
            self.all.each do |obj|
                if obj.slug == slug
                    result << obj
                end
            end
            result.size == 1 ? result[0] : nil
        end
    end

    module InstanceMethods
        def slug
            string = self == 'Wizard' ? self.username : self.name
            string.downcase.gsub(/\W/," ").gsub(/\s+/," ").gsub(" ","-")
        end
    end
end