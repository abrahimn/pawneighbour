class Offer < ApplicationRecord
  belongs_to :listing
  belongs_to :user
  validates :status, presence: true
end
