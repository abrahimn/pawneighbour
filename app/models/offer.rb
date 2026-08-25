class Offer < ApplicationRecord
  belongs_to :listing
  belongs_to :user

  scope :pending, -> { where(status: "offered") }
  scope :accepted, -> { where(status: "accepted") }
  scope :rejected, -> { where(status: "rejected") }

  validates :status, presence: true
  validates :user_id, uniqueness: { scope: :listing_id, message: "already offered on this listing" }
  validate :not_own_listing

  private

  def not_own_listing
    return unless user == listing.owner

    @errors.add(:base, "You can't offer on your own listing")
  end
end
