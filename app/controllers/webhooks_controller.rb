class WebhooksController < ApplicationController

  skip_before_action :check_nexmo_api_credentials
  skip_before_action :verify_authenticity_token

  def inbound
    event = EventLog.create(app_id: params[:app_id], event_type: 'inbound', content: request.body.read)
    render json: 'ok'
  end

  def status
    event = EventLog.create(app_id: params[:app_id], event_type: 'status', content: request.body.read)
    puts event
    render json: 'ok'
  end

  def set_nexmo_app
    redirect_to root_url and return if params[:app_id].blank?
    @nexmo_app = NexmoApp.where(app_id: params[:app_id]).first
    redirect_to app_reset_url and return if @nexmo_app.blank?
  end

end
