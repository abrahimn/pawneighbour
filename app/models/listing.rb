class Listing < ApplicationRecord
  TYPES = ["Sitting", "Drop-in", "Walking"].freeze

  belongs_to :pet
  has_many :offers, dependent: :destroy

  validates :listing_type, presence: true, inclusion: { in: TYPES }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :end_date, comparison: { greater_than_or_equal_to: :start_date }
  scope :active, -> { where("start_date > ?", Time.zone.today).order(:start_date, :id) }
end
