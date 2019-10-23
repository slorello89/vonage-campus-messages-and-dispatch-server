class NexmoAppController < ApplicationController
  skip_before_action :set_nexmo_app, only: [:setup, :create, :reuse, :reset]


  def regenerate_keys
    key = OpenSSL::PKey::RSA.generate(2048)
    if !@nexmo_app.update(public_key: key.public_key, private_key: key.to_s)
      redirect_to app_url, alert: 'Could not regenerate keys'
      return
    end
    unless NexmoApi.app_update(@nexmo_app, session[:api_key], session[:api_secret])
      redirect_to app_url, alert: 'Nexmo app could not be updated on the Nexmo servers.'
      return
    end
    redirect_to app_url, notice: "Nexmo app keys were successfully updated."
  end


  # APP KEYS

  def public_key
    send_data @nexmo_app.public_key,
      :disposition => "attachment; filename=public.key"
  end
  def private_key
    send_data @nexmo_app.private_key,
      :disposition => "attachment; filename=private.key"
  end



  # APP SETUP

  def setup
    if NexmoApp.where(api_key: session[:api_key]).count > 0
      redirect_to app_url and return
    end
    @nexmo_app = NexmoApp.new
    @existing_apps = NexmoApi.apps(session[:api_key], session[:api_secret]).select { |app| app.capabilities.messages != nil }
  end

  def reuse
    @existing_app = NexmoApi.apps(session[:api_key], session[:api_secret]).select{|app| app.id == params[:id]}.first

    key = OpenSSL::PKey::RSA.generate(2048)
    @nexmo_app = NexmoApp.new(
      api_key: session[:api_key],
      app_id: @existing_app.id, name: @existing_app.name, 
      inbound_url: webhooks_inbound_url(app_id: @existing_app.id), inbound_url_method: "POST",
      status_url: webhooks_status_url(app_id: @existing_app.id), status_url_method: "POST",
      public_key: key.public_key, private_key: key.to_s
    )
    unless @nexmo_app.save
      render action: :setup, alert: 'Something went wrong' and return
    end

    unless NexmoApi.app_update(@nexmo_app, session[:api_key], session[:api_secret])
      redirect_to app_url, alert: 'Nexmo app could not be updated on the Nexmo servers.'
      return
    end
    redirect_to app_url, notice: "Nexmo app was successfully set up."
  end


  def reset
    # EventLog.destroy_all
    NexmoApp.where(api_key: session[:api_key]).destroy_all
    redirect_to app_setup_url
  end


  private

  def nexmo_app_params
    params.require(:nexmo_app).permit(:name)
  end

end
