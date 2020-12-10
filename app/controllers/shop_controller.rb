class ShopController < ApplicationController

    get '/shop' do
        @wands = Wand.all.order(id: :desc).where(wizard: nil).limit(8)
        @spells = Spell.all.order(id: :desc).includes(:wizards).limit(8)
        @wand = current_wizard.wand

        erb :'shop/index'
    end

end