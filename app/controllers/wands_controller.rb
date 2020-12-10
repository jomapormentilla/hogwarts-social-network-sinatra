class WandsController < ApplicationController
    
    get '/wands' do
        @wands = Wand.all.includes(:wizard).order(price: :asc)
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
end