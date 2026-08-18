class OffersController < ApplicationController
  def index
  end

  def show
  end

  def create
    @listing = Listing.find(params[:listing_id])
    @offer = @listing.offers.new(user: current_user, status: "offered")

    if @offer.save
      redirect_to @listing, notice: "Offer sent to #{@listing.pet.user.name}"
    else
      redirect_to @listing, status: :unprocessable_entity
    end
  end
end
