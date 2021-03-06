class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :check_if_first_use

  def check_if_first_use
    silence_action do
      if ApplicationConfiguration.count == 0
        redirect_to welcome_settings_path, layout: false
      end
    end
  end

  def silence_action
    Rails.logger.silence do
      yield
    end
  end

end
