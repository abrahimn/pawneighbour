class ListingsController < ApplicationController
  def index
    @listings = Listing.all
    @active_listings = Listing.active
  end
end
