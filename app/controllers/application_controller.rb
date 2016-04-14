class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # tell Devise where to go on successful sign-in
  def after_sign_in_path_for(resource)
    games_path
  end

  def after_sign_out_path_for(resource)
    static_pages_goodbye_path
  end
end
