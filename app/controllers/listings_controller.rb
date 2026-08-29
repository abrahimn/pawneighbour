class ListingsController < ApplicationController
  def index
    set_search_area
    @nearby_listings = nearby_listings
  end

  def mine
    @my_listings = my_active_listings.to_a
    @attention_listings = @my_listings.select do |listing|
      listing.accepted_offer.blank? && listing.pending_offers.any?
    end
    @current_offers = activity_offers.where(status: %w[offered accepted]).to_a
    @past_offers = past_offers.to_a
  end

  def new
    redirect_to listings_path, alert: "Add a pet before posting a job." and return if current_user.pets.none?

    @listing = Listing.new
    @pets = current_user.pets.order(:name)
  end

  def create
    @listing = current_user.listings.build(listing_params)

    if @listing.save
      redirect_to listing_path(@listing), notice: "Your job was posted."
    else
      @pets = current_user.pets.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @listing = Listing.find(params[:id])
    @accepted_offer = @listing.accepted_offer

    @matched_user =
      if @listing.owner == current_user
        @accepted_offer&.user
      elsif @accepted_offer&.user == current_user
        @listing.owner
      end
  end

  private

  def set_search_area
    @latitude = current_user.latitude || -33.8688
    @longitude = current_user.longitude || 151.2093
    @radius = (params[:radius].presence || 3).to_i
  end

  def nearby_listings
    nearby_user_ids = User.near([@latitude, @longitude], @radius, units: :km).map(&:id)

    Listing.available
           .where(user_id: nearby_user_ids - [current_user.id])
           .where.not(id: current_user.offers.select(:listing_id))
           .includes(:owner, pets: { avatar_attachment: :blob })
  end

  def my_active_listings
    current_user.listings.active.includes(:pets, :pending_offers, accepted_offer: :user)
  end

  def activity_offers
    current_user.offers
                .joins(:listing)
                .merge(Listing.active)
                .includes(listing: %i[owner pets])
                .order("offers.updated_at DESC")
  end

  def past_offers
    current_user.offers.rejected
                .includes(listing: %i[owner pets])
                .order(updated_at: :desc)
  end

  def listing_params
    params.require(:listing).permit(
      :listing_type,
      :start_date,
      :end_date,
      :listing_note,
      pet_ids: []
    )
  end
end
