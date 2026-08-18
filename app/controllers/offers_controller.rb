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
end
