class OffersController < ApplicationController
  def index
    @listing = Listing.find(params[:listing_id])

    if @listing.pet.user != current_user
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

  def accept
    @offer = Offer.find(params[:id])
    @listing = @offer.listing

    if @listing.owner != current_user
      redirect_to listing_path(@listing),
                  alert: "You are not authorized to accept this offer."
      return
    end

    # with_lock ensures acceptance, rejections and connects happen together
    @listing.with_lock do
      accepted_offer = @listing.offers.find_by(status: "accepted")

      if accepted_offer.present? && accepted_offer != @offer
        redirect_to listing_offers_path(@listing),
                    alert: "An offer has already been accepted."
        return
      end

      # Accept the selected offer
      @offer.update!(status: "accepted")

      # Reject the other offers
      @listing.offers
              .where.not(id: @offer.id)
              .update_all(status: "rejected", updated_at: Time.current)

      Connection.find_or_create_by!(
        sender: @listing.owner,
        receiver: @offer.user
      )
    end

    redirect_to listing_path(@listing),
                notice: "You matched with #{@offer.user.name}!"
  end
end
