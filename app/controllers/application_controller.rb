class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  
  layout :layout_by_resource
  
  def info_for_paper_trail
    if current_user
      { :user_id => current_user.id }
    end
  end

  def layout_by_resource
    if devise_controller?
      "login"
    else
      "application"
    end
  end
  
  
end
