class HomeController < ApplicationController

  def index
    redirect_to dashboard_path if customer_signed_in?
  end
end
