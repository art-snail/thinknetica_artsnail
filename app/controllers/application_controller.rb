require 'application_responder'

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :gon_user

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.js { render partial: 'common/alert', locals: { error: exception.message }, status: :forbidden }
      format.json { render json: { error: exception.message }, status: :forbidden }
    end
  end

  check_authorization unless: :devise_controller?

  private

  def gon_user
    gon.current_user = current_user if current_user
  end
end
