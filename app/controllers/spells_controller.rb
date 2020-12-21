class SpellsController < ApplicationController
    
    get '/spells' do
        if params[:search_term]
            if params[:type] == 'name'
                @spells = Spell.all.includes_custom( params )
                flash[:message] = "#{ @spells.size } Spell#{ @spells.size != 1 ? 's' : nil} Found."
            elsif params[:type] == 'price'
                @spells = Spell.all.includes(:wizards).order(price: :desc).where("#{ params[:type] } < ?", "#{ params[:search_term] }")
                flash[:message] = "Found #{ @spells.size } spells under #{ params[:search_term] } Sickles."
            end
            
            if @spells.empty?
                flash[:message] = "No spells found."
                flash[:alert_type] = "danger"
                redirect "/spells"
            end

            flash[:alert_type] = "success"
        else
            @spells = Spell.all.includes(:wizards).order(:name => 'asc')
        end

        @wand = current_wizard.wand

        erb :'shop/spells/index'
    end

    get '/spells/:slug' do
        @spell = Spell.find_by_slug(params[:slug])
        redirect_if_obj_not_found( @spell )

        @wand = current_wizard.wand

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
            flash[:alert_type] = "danger"

            redirect "/spells"
        end

        redirect_to_previous_page( request )
    end
end