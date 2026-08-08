class Listing < ApplicationRecord
  belongs_to :pet
  has_many :offers, dependent: :destroy
  validates :listing_type, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :end_date, comparison: { greater_than_or_equal_to: :start_date }
end
