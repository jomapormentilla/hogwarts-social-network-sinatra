require_relative '../config/environment'

def self.start
    house_data
    spell_data
    wizard_data
    wand_data
    post_data
    comment_data
    upvote_data
end

def wizard_data
    50.times do
        name = Faker::Movies::HarryPotter.unique.character
        username = name.downcase
    
        data = {
            username: username.gsub(" ","_"),
            name: name,
            email: "#{ username.gsub(" ",".") }@flatiron-school.com",
            balance: 1000,
            house_id: House.all.sample.id
        }

        Wizard.create(data)
    end

    assign_friends
end

def assign_friends
    Wizard.all.each do |wizard|
        wizard.friends << Wizard.all.sample
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
        h.founder = tbody.css("td")[2].css("p").text
        h.head_master = tbody.css("td")[10].css("p").text
        h.mascot = tbody.css("td")[6].css("p").text
        h.save
    end
end

def wand_data
    100.times do
        data = {
            name: "The #{ Faker::Verb.ing_form.capitalize } #{ Faker::Creature::Animal.name.capitalize }",
            price: rand(50...250)
        }

        wand = Wand.create(data)
    end
end

def post_data
    30.times do
        data = {
            title: Faker::Quote.unique.famous_last_words,
            content: Faker::TvShows::MichaelScott.quote,
            timestamp: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now),
            wizard_id: Wizard.all.sample.id
        }

        Post.create(data)
    end
end

def comment_data
    27.times do
        data = {
            content: Faker::TvShows::Community.unique.quotes,
            timestamp: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now),
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

self.start