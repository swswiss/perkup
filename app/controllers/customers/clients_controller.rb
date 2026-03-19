class Customers::ClientsController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_customer!

  def index
    @pagy, @clients = pagy(clients_scope, items: 10)
    @total = clients_scope.count
  end

  def search
    @pagy, @clients = pagy(clients_scope, items: 10)
    @total = clients_scope.count
    render partial: "clients_list"
  end

  private

  def clients_scope
    scope = User.order(created_at: :desc)

    if params[:q].present? && params[:q].strip.length >= 2
      q = "%#{params[:q].strip.downcase}%"
      scope = scope.where(
        "LOWER(first_name || ' ' || last_name) LIKE ? OR LOWER(email) LIKE ?", q, q
      )
    end

    scope
  end

  def current_card
    @current_card ||= current_customer.cards.first
  end
end