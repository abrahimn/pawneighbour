class ListingsController < ApplicationController
  def index
    @active_listings = Listing.active
    @markers = @active_listings.map do |listing|
      {
        id: listing.id,
        lat: listing.owner.latitude,
        lng: listing.owner.longitude,
        infoWindow: { content: render_to_string(partial: "/listings/map_info_window", locals: { listing: listing }) }
      }
    end
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
