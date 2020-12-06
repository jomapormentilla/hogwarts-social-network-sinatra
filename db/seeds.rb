def self.start

end

def self.wizard_data
    
end

def self.spells_data
    url = "https://www.pojo.com/harry-potter-spell-list/"
        
    html = Nokogiri::HTML(open(url))

    html.css("tbody tr").each do |tbody|
        if tbody.css("td")[0].text != "Incantation" && tbody.css("td")[0].text.length > 3
            s = Spell.new
            s.name = tbody.css("td")[0].text
            s.effect = tbody.css("td")[2].text
            s.save
        end
    end
end

def self.house_data
    url = "https://pottermore.fandom.com/wiki/Houses"

    html = Nokogiri::HTML(open(url))

    html.css(".infoboxtable tbody").each do |tbody|
        h = House.new
        h.name = tbody.css("td")[2].css("p").text.split[1]
        h.founder = tbody.css("td")[2].css("p").text
        h.head_master = tbody.css("td")[10].css("p").text
        h.mascot = tbody.css("td")[6].css("p").text
        h.save
    end
end