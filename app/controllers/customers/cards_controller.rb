class Customers::CardsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_card, only: [:show, :edit, :update, :destroy]

  def index
    @cards = current_customer.cards
  end

  def show
  end

  def new
    @card = current_customer.cards.build
  end

  def create
    binding.pry
    @card = current_customer.cards.build(card_params)
    if @card.save
      redirect_to customers_cards_path, notice: "Card created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @card.update(card_params)
      redirect_to customers_cards_path, notice: "Card updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @card.destroy
    redirect_to customers_cards_path, notice: "Card deleted successfully."
  end

  private

  def set_card
    @card = current_customer.cards.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:name, :reward_rule, :product, :reward, :description, :color)
  end  
end
