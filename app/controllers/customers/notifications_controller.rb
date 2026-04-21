# frozen_string_literal: true

class Customers::NotificationsController < ApplicationController
  before_action :authenticate_customer!

  def new
    @title = ""
    @body = ""
    @url = "/"
  end

  def create
    @title = params[:title].to_s.strip
    @body  = params[:body].to_s.strip
    @url   = params[:url].presence || "/"

    if @title.blank? || @body.blank?
      flash.now[:alert] = "Titlul si mesajul sunt obligatorii."
      render :new, status: :unprocessable_entity and return
    end

    result = PushNotificationService.broadcast(title: @title, body: @body, url: @url)

    flash[:notice] = "Notificare trimisa: #{result.sent} livrate, #{result.expired} expirate, #{result.failed} esuate."
    redirect_to new_customers_notification_path
  end
end
