class Listing < ApplicationRecord
  TYPES = ["Sitting", "Drop-in", "Walking"].freeze

  belongs_to :pet
  has_one :owner, through: :pet, source: :user
  has_many :offers, dependent: :destroy

  has_many :pending_offers,
           -> { where(status: "offered") },
           class_name: "Offer"

  has_one :accepted_offer,
          -> { where(status: "accepted") },
          class_name: "Offer"

  validates :listing_type, presence: true, inclusion: { in: TYPES }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :end_date, comparison: { greater_than_or_equal_to: :start_date }

  scope :active, -> { where("start_date >= ?", Time.zone.today).order(:start_date, :id) }
  scope :available, -> { active.where.not(id: Offer.accepted.select(:listing_id)) }
end
