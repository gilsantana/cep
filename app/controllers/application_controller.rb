class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :controles
  
  layout :layout_by_resource
  
  def controles
    @controls = Control.where(['user_id = ? OR publico=?', current_user.id, true]).order("created_at DESC")
  end
  
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
