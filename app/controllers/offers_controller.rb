class OffersController < ApplicationController
  def index
    @listing = Listing.find(params[:listing_id])

    unless @listing.pet.user == current_user
      redirect_to listing_path(@listing), alert: "You are not authorized to view these offers."
      return
    end

    @offers = @listing.offers
  end

  def show
  end

  def create
    @listing = Listing.find(params[:listing_id])
    @offer = @listing.offers.new(user: current_user, status: "offered")

    if @offer.save
      redirect_to @listing, notice: "Offer sent to #{@listing.owner.name}"
    else
      redirect_to @listing, alert: @offer.errors.full_messages.to_sentence
    end
  end
end
