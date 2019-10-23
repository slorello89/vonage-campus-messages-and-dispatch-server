class ExternalAccountsController < ApplicationController

  def index
    begin
      tmp = NexmoApi.external_accounts(@nexmo_app)
      @accounts = tmp[:_embedded]
      @accounts.each do |app|
        if app[:provider] == 'whatsapp' && !app[:applications].blank? && app[:applications].include?(@nexmo_app.app_id)
          @nexmo_app.update(whatsapp_number: app[:external_id])
        end
        if app[:provider] == 'viber_service_msg' && !app[:applications].blank? && app[:applications].include?(@nexmo_app.app_id)
          @nexmo_app.update(viber_id: app[:external_id])
        end
      end
    rescue
      @accounts = []
    end
  end


end
