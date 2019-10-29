require 'json'

class MessagesController < ApplicationController
  before_action :set_app_jwt

  def sms
    @page_title = "Send an SMS"
  end

  def mms
    @page_title = "Send an MMS"
  end

  def messenger
    @page_title = "Facebook Messenger"
    event = EventLog.where("app_id = ? AND event_type = ? AND content ILIKE ?", @nexmo_app.app_id, "inbound", '%"type":"messenger"%').order(created_at: :desc).first
    unless event.blank?
      @inbound = JSON.parse(event.content, object_class: OpenStruct)
    end
  end

  def whatsapp
    @whatsAppPhoneNumber = @nexmo_app.whatsapp_number || "No WhatsApp external account found"
    @page_title = "WhatsApp"
    event = EventLog.where("app_id = ? AND event_type = ? AND content ILIKE ?", @nexmo_app.app_id, "inbound", '%"type":"whatsapp"%').order(created_at: :desc).first
    unless event.blank?
      @last_message = JSON.parse(event.content, object_class: OpenStruct)
    end
  end

  def viber
    @viber_id = @nexmo_app.viber_id || "No Viber external account found"
    @page_title = "Viber"
  end

  def switch_os
    if params[:os].blank? ||  !(["windows", "mac"].include?(params[:os]))
      rredirect_back fallback_location: root_path, alert: "Invalid OS"
      return
    end
    session[:os] = params[:os]
    redirect_back fallback_location: root_path
  end
  private

  def set_app_jwt
    @app_jwt = NexmoApi.generate_admin_jwt(@nexmo_app)
    session[:os] ||= "mac"
    @os = session[:os]
  end
end
