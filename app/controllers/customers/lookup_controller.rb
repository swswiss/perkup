class Customers::LookupController < ApplicationController
  before_action :authenticate_customer!

  def index
    @top_stamps  = UserCard.where(card: current_card)
                            .order(points: :desc)
                            .limit(5)
                            .includes(:user)

    @top_coupons = User.joins(:coupons)
                        .where(coupons: { card: current_card })
                        .group("users.id")
                        .order("COUNT(coupons.id) DESC")
                        .limit(5)
                        .select("users.*, COUNT(coupons.id) as coupons_count")
  end

  def search
    query = params[:q].to_s.strip
    if query.length >= 2
      @users = User.joins(:user_cards)
                    .where(user_cards: { card: current_card })
                    .where("LOWER(first_name || ' ' || last_name) LIKE ?",
                          "%#{query.downcase}%")
                    .limit(8)
                    .includes(:user_cards)
    else
      @users = []
    end

    render partial: "search_results"
  end

  def show
    @user      = User.find(params[:id])
    @user_card = UserCard.find_by(user: @user, card: current_card)
    @stamps    = @user_card&.stamps&.order(created_at: :desc)&.limit(10) || []
    @coupons   = @user.coupons.where(card: current_card).order(created_at: :desc)
    @stats     = {
      stamps:  @user_card&.stamps&.count || 0,
      points:  @user_card&.points || 0,
      coupons: @coupons.count,
      since:   @user_card&.created_at&.strftime("%b %Y") || "—"
    }

    render partial: "user_panel"
  end

  private

  def current_card
    @current_card ||= current_customer.cards.first
  end
end
