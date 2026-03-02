class Customers::ScansController < ApplicationController
  before_action :authenticate_customer!

  def show
    @card = current_customer.cards.find_by(uuid: params[:uuid])

    if @card.nil?
      render plain: "Invalid QR code", status: :not_found
      return
    end
  end
end