# frozen_string_literal: true

class Customers::DashboardController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_customer!

  def index
    my_loyalty_card
  end

  def count_users
    @users_count = Rails.cache.fetch("dashboard_users_count", expires_in: 10.hours) do
      User.count
    end

    @users_this_month = Rails.cache.fetch("dashboard_users_this_month_count", expires_in: 10.hours) do
      User.where(created_at: Time.current.beginning_of_month..Time.current).count
    end

    render partial: "users_widget"
  end

  def count_stamps
    @points_total = Rails.cache.fetch("dashboard_points_total", expires_in: 10.hours) do
      UserCard.sum(:points)
    end

    @points_total_this_month = Rails.cache.fetch("dashboard_points_this_month", expires_in: 10.hours) do
      Stamp.where(created_at: Time.current.all_month).count
    end

    render partial: "stamps_widget"
  end

  def count_coupons
    @coupons_total = Rails.cache.fetch("dashboard_coupons_total", expires_in: 10.hours) do
      Coupon.count
    end

    @coupons_total_this_month = Rails.cache.fetch("dashboard_coupons_this_month", expires_in: 10.hours) do
      Coupon.where(created_at: Time.current.all_month).count
    end

    render partial: "coupons_widget"
  end

  def activity
    @pagy, @activities = pagy(Stamp.order(created_at: :desc), items: 4)

    render partial: "activity_widget"
  end

  def coupons
    @pagy, @coupons = pagy(Coupon.order(created_at: :desc), items: 4)

    render partial: "coupons_data_widget"
  end

  private
  def my_loyalty_card
    @card = current_customer.cards.first
  end
end
