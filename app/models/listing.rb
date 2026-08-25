class Listing < ApplicationRecord
  TYPES = ["Sitting", "Drop-in", "Walking"].freeze

  belongs_to :owner, class_name: "User", foreign_key: :user_id
  has_many :listing_pets, dependent: :destroy
  has_many :pets, through: :listing_pets
  has_many :offers, dependent: :destroy

  has_many :pending_offers,
           -> { where(status: "offered") },
           class_name: "Offer"

  has_one :accepted_offer,
          -> { where(status: "accepted") },
          class_name: "Offer"

  validates :listing_type, presence: true, inclusion: { in: TYPES }
  validates :start_date, presence: true
  validates :pets, presence: true
  validates :pets_belong_to_owner
  validates :end_date, presence: true
  validates :end_date, comparison: { greater_than_or_equal_to: :start_date }

  scope :active, -> { where("start_date >= ?", Time.zone.today).order(:start_date, :id) }
  scope :available, -> { active.where.not(id: Offer.accepted.select(:listing_id)) }

  private

  def pets_belong_to_owner
    return if pets.all? { |pet| pet.user_id == user_id }

    errors.add(:pets, "must be your own pets")
  end
end
