class SpellsController < ApplicationController
    
    get '/spells' do
        sort_by = "name"
        
        if params[:sort] == 'price'
            sort_by = "price"
        elsif params[:sort] == 'name'
            sort_by = "name"
        end

        @spells = Spell.all.includes(:wizards).order(sort_by.to_sym => 'asc')
        @wand = current_wizard.wand

        erb :'shop/spells/index'
    end

    get '/spells/:slug' do
        @spell = Spell.find_by_slug(params[:slug])
        redirect_if_obj_not_found( @spell )

        erb :'shop/spells/show'
    end

    post '/spells/:slug' do
        spell = Spell.find_by_slug(params[:slug])
        redirect_if_obj_not_found( spell )

        new_balance = current_wizard.balance - spell.price

        if new_balance > 0
            current_wizard.update(balance: new_balance)
            current_wizard.spells << spell

            flash[:message] = "Congratulations! You just learned <b>#{ spell.name }</b>!"
            flash[:alert_type] = "success"
        else
            flash[:message] = "You do not have enough funds to learn this spell."
            flash[:alert_type] = "warning"
        end

        redirect_to_previous_page( request )
    end

    get '/spells/:slug/edit' do

    end
end