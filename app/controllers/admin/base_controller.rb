class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!
  def authenticate_admin!
    authenticate_user!
    redirect_to root_path unless current_user.admin?
  end
end
