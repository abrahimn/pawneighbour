class ListingsController < ApplicationController
  def index
    @listings = Listing.all
    @active_listings = Listing.active
  end

  def new
    @listing = Listing.new
    @pets = current_user.pets.order(:name)
  end

  def create
    @pet = current_user.pets.find(params[:listing][:pet_id])
    @listing = @pet.listings.build(listing_params)

    if @listing.save
      redirect_to listing_path(@listing), notice: "Your job was posted."
    else
      @pets = current_user.pets.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @listing = Listing.find(params[:id])
    @accepted_offer = @listing.offers.find_by(status: "accepted")

    @matched_user =
      if @listing.owner == current_user
        @accepted_offer&.user
      elsif @accepted_offer&.user == current_user
        @listing.owner
      end
  end

  private

  def listing_params
    params.require(:listing).permit(
      :listing_type,
      :start_date,
      :end_date,
      :listing_note
    )
  end
end
