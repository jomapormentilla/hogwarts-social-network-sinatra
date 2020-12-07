class SpellsController < ApplicationController
    get '/spells' do
        erb :'spells/index'
    end
end