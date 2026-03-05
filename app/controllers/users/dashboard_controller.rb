# frozen_string_literal: true

class Users::DashboardController < ApplicationController
	before_action :authenticate_user!
	
	def index
    @user_card = current_user.user_cards.first
    @card = @user_card&.card
    @stamps = @user_card&.stamps
    
    count = @stamps&.count.to_i
    max = @card&.reward_rule.to_i
    @how_many_stamps_on_user_card = 
      if max > 0 && count % max == 0 && count > 0
        max
      elsif max > 0
        count % max
      else
        0
      end
    @empty_stamps = @card&.reward_rule - @how_many_stamps_on_user_card rescue nil
    @last_4_stamps = @user_card&.stamps&.last(4)
	end
end
