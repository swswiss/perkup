class HomeController < ApplicationController

  def index
    redirect_to customers_dashboard_path if customer_signed_in?
    redirect_to users_dashboard_path if user_signed_in?
  end
end
