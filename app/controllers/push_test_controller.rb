# app/controllers/push_test_controller.rb
class PushTestController < ApplicationController
    protect_from_forgery with: :exception
  
    def create
      user = User.first
      PushNotificationService.call(
        user: user,
        title: params[:title],
        body: params[:body],
        url: params[:url] || "/"
      )
  
    end
  end
  