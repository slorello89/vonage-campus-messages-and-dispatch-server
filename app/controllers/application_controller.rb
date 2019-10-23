class ApplicationController < ActionController::Base
  before_action :check_nexmo_api_credentials
  before_action :set_nexmo_app

  private

  def check_nexmo_api_credentials
    redirect_to root_url and return if session[:api_key].blank? || session[:api_secret].blank?
  end


  def set_nexmo_app
    redirect_to root_url and return if session[:api_key].blank?
    @nexmo_app = NexmoApp.where(api_key: session[:api_key]).first
    redirect_to app_reset_url and return if @nexmo_app.blank?
  end


end
