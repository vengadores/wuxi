class HomeController < ApplicationController
  before_action :redirect_admin,
                if: :user_signed_in?

  def index
  end

  private

  def redirect_admin
    redirect_to admin_root_path
  end
end
