require_relative '../config/environment'

def self.start
    house_data
    spell_data
    wizard_data
    wand_data
    post_data
    comment_data
    upvote_data
    wizard_image_data
    wand_image_data
end

def wizard_data
    founder_data
    head_master_data

    50.times do
        name = Faker::Movies::HarryPotter.unique.character
        username = name.downcase
    
        data = {
            username: username.gsub(" ","_"),
            name: name,
            email: "#{ username.gsub(" ",".") }@hogwarts.edu",
            password: "plokijuh",
            balance: 1000,
            house_id: House.all.sample.id
        }

        search = Wizard.find_by_name(name)

        if !search
            wizard = Wizard.create(data)
        end
    end

    assign_friends
    assign_house_faculty
end

def founder_data
    founders = [
        {
            username: "thelionking",
            name: "Godric Gryffindor",
            email: "g.gryffindor@hogwarts.edu",
            password: "plokijuh",
            balance: 1000
        },
        {
            username: "thesnakelord",
            name: "Salazar Slytherin",
            email: "s.slytherin@hogwarts.edu",
            password: "plokijuh",
            balance: 1000
        },
        {
            username: "powerpuffgirl",
            name: "Helga Hufflepuff",
            email: "h.hufflepuff@hogwarts.edu",
            password: "plokijuh",
            balance: 1000
        },
        {
            username: "thebirdlady",
            name: "Rowena Ravenclaw",
            email: "r.ravenclaw@hogwarts.edu",
            password: "plokijuh",
            balance: 1000
        }
    ]

    founders.each do |wizard|
        Wizard.create(wizard)
    end
end

def head_master_data
    head_masters = [
        {
            username: "missmcgonagall",
            name: "Minerva McGonagall",
            email: "m.mcgonagall@hogwarts.edu",
            password: "plokijuh",
            balance: 1000
        },
        {
            username: "thebadguy",
            name: "Severus Snape",
            email: "s.snape@hogwarts.edu",
            password: "plokijuh",
            balance: 1000
        },
        {
            username: "misspomona",
            name: "Pomona Sprout",
            email: "p.sprout@hogwarts.edu",
            password: "plokijuh",
            balance: 1000
        },
        {
            username: "thebirdman",
            name: "Filius Flitwick",
            email: "f.flitwick@hogwarts.edu",
            password: "plokijuh",
            balance: 1000
        }
    ]
    
    head_masters.each do |wizard|
        Wizard.create(wizard)
    end
end

def assign_friends
    Wizard.all.each do |wizard|
        wizard.friends << Wizard.all.sample
        wizard.save
    end
end

def spell_data
    url = "https://www.pojo.com/harry-potter-spell-list/"
        
    html = Nokogiri::HTML(open(url))

    html.css("tbody tr").each do |tbody|
        if tbody.css("td")[0].text != "Incantation" && tbody.css("td")[0].text.length > 3
            s = Spell.new
            s.name = tbody.css("td")[0].text
            s.effect = tbody.css("td")[2].text
            s.price = rand(50...250)
            s.img_url = "/images/spell-img.png"
            s.save
        end
    end
end

def house_data
    url = "https://pottermore.fandom.com/wiki/Houses"

    html = Nokogiri::HTML(open(url))

    html.css(".infoboxtable tbody").each do |tbody|
        h = House.new
        h.name = tbody.css("td")[2].css("p").text.split[1]
        h.mascot = tbody.css("td")[6].css("p").text
        h.save
    end
end

def assign_house_faculty
    House.all.each do |house|
        if house.name == "Gryffindor"
            wizard1 = Wizard.find_by_name("Godric Gryffindor")
            wizard2 = Wizard.find_by_name("Minerva McGonagall")
            house.img_url = "/images/gryffindor-logo.jpg"
        elsif house.name == "Slytherin"
            wizard1 = Wizard.find_by_name("Salazar Slytherin")
            wizard2 = Wizard.find_by_name("Severus Snape")
            house.img_url = "/images/slytherin-logo.jpg"
        elsif house.name == "Hufflepuff"
            wizard1 = Wizard.find_by_name("Helga Hufflepuff")
            wizard2 = Wizard.find_by_name("Pomona Sprout")
            house.img_url = "/images/hufflepuff-logo.jpg"
        elsif house.name == "Ravenclaw"
            wizard1 = Wizard.find_by_name("Rowena Ravenclaw")
            wizard2 = Wizard.find_by_name("Filius Flitwick")
            house.img_url = "/images/ravenclaw-logo.jpg"
        end

        wizard1.house_id = house.id
        wizard2.house_id = house.id
        
        house.founder = wizard1
        house.head_master = wizard2
        
        house.save
    end
end

def wand_data
    60.times do
        data = {
            name: "#{ Faker::Verb.ing_form.capitalize } #{ Faker::Creature::Animal.name.capitalize }",
            price: rand(50...250),
            wizard_id: Wizard.all.sample
        }

        wand = Wand.create(data)
    end
end

def post_data
    30.times do
        data = {
            title: Faker::Quote.unique.famous_last_words,
            content: Faker::Lorem.paragraph_by_chars,
            timestamp: Faker::Time.between(from: DateTime.now - 365, to: DateTime.now),
            wizard_id: Wizard.all.sample.id
        }

        Post.create(data)
    end
end

def comment_data
    27.times do
        data = {
            content: Faker::TvShows::Community.unique.quotes,
            timestamp: Faker::Time.between(from: DateTime.now - 365, to: DateTime.now),
            wizard_id: Wizard.all.sample.id,
            post_id: Post.all.sample.id
        }

        Comment.create(data)
    end
end

def upvote_data
    200.times do
        data = {
            wizard_id: Wizard.all.sample.id,
            post_id: Post.all.sample.id
        }
        
        upvote = Upvote.create(data)
    end
end

def wizard_image_data
    url = "https://www.gettyimages.com/photos/harry-potter?family=editorial&phrase=harry%20potter&sort=mostpopular"
        
    html = Nokogiri::HTML(open(url))

    Wizard.all.each.with_index do |wizard, index|
        wizard.img_url = html.css(".gallery-mosaic-asset article a figure img")[index].attr("src")
        wizard.save
    end
end

def wand_image_data
    url = "https://www.gettyimages.com/photos/wand?family=creative&license=rf&mediatype=photography&phrase=wand&sort=mostpopular"
        
    html = Nokogiri::HTML(open(url))

    Wand.all.each.with_index do |wand, index|
        wand.img_url = html.css(".gallery-mosaic-asset article a figure img")[index].attr("src")
        wand.save
    end
end

self.start