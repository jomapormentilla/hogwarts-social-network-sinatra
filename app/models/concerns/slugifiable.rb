module Slugifiable
    module ClassMethods
        def find_by_slug( slug )
            self.all.each do |song|
                if song.slug == slug
                    return song
                end
            end
        end
    end

    module InstanceMethods
        def slug
            string = self.name || self.title
            string.downcase.gsub(/\W/," ").gsub(/\s+/," ").gsub(" ","-")
        end
    end
end