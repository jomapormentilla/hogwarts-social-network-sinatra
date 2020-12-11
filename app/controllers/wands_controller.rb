class WandsController < ApplicationController
    
    get '/wands' do
        if params[:search_term]
            if params[:type] == 'name'
                @wands = Wand.all.includes(:wizard).order(:name => 'asc').where("#{ params[:type] } like ?", "%#{ params[:search_term] }%")
                flash[:message] = "#{ @wands.size } Wands Found."
                flash[:alert_type] = "success"
            elsif params[:type] == 'price'
                @wands = Wand.all.includes(:wizard).order(price: :desc).where("#{ params[:type] } < ?", "#{ params[:search_term] }")
                flash[:message] = "Found #{ @wands.size } wands under #{ params[:search_term] } Sickles."
                flash[:alert_type] = "success"
            end
            
            if @wands == []
                flash[:message] = "No wands found."
                flash[:alert_type] = "danger"
                redirect "/wands"
            end
        else
            @wands = Wand.all.includes(:wizard).order(:name => 'asc')
        end

        @wand = current_wizard.wand
        
        erb :'shop/wands/index'
    end

    get '/wands/:slug' do
        @wand = Wand.find_by_slug(params[:slug])
        erb :'shop/wands/show'
    end

    post '/wands/:slug' do
        wand = Wand.find_by_slug(params[:slug])
        redirect_if_obj_not_found( wand )

        new_balance = current_wizard.balance - wand.price

        if new_balance > 0
            current_wizard.update(balance: new_balance)
            wand.update(wizard_id: current_wizard.id)
            flash[:message] = "You are now the proud owner of <b>#{ wand.name }</b>"
            flash[:alert_type] = "success"
        else
            flash[:message] = "You do not have enough funds to equip this wand."
            flash[:alert_type] = "warning"
        end

        redirect_to_previous_page( request )
    end

    post '/wands/:slug/trade' do
        wand = Wand.find_by_slug(params[:slug])
        redirect_if_obj_not_found( wand )

        current_wand = current_wizard.wand
        trade_in_cost = current_wand.price/2
        new_balance = current_wizard.balance + trade_in_cost

        cost = new_balance - wand.price

        if cost > 0
            current_wand.update(wizard_id: nil)
            current_wizard.reload

            wand.update(wizard_id: current_wizard.id)
            current_wizard.update(balance: cost)

            flash[:message] = "You are now the proud owner of <b>#{ wand.name }</b>"
            flash[:alert_type] = "success"
        else
            flash[:message] = "You do not have enough funds to equip this wand."
            flash[:alert_type] = "danger"
        end

        redirect_to_previous_page( request )
    end

    post '/wands/:slug/unequip' do
        wand = Wand.find_by_slug(params[:slug])
        redirect_if_obj_not_found( wand )
        
        new_balance = current_wizard.balance + (wand.price/2)

        wand.update(wizard_id: nil)
        current_wizard.reload
        current_wizard.update(balance: new_balance)

        flash[:message] = "Sucessfully sold #{ wand.name }. You no longer own a wand."
        flash[:alert_type] = "success"
        redirect_to_previous_page( request )
    end
end