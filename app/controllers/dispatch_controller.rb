require 'json'


class DispatchController < ApplicationController
  before_action :set_app_jwt

  def index
    event = EventLog.where("app_id = ? AND event_type = ? AND content ILIKE ?", @nexmo_app.app_id, "inbound", '%"type":"messenger"%').order(created_at: :desc).first
    unless event.blank?
      @inbound = JSON.parse(event.content, object_class: OpenStruct)
    end
  end

  private

  def set_app_jwt
    @app_jwt = NexmoApi.generate_admin_jwt(@nexmo_app)
  end

end
