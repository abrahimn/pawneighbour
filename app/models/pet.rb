class Pet < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar
  has_many :listing_pets, dependent: :destroy
  has_many :listings, through: :listing_pets
  has_many :amber_alerts, dependent: :destroy
  validates :name, :age, presence: true
  validates :species, presence: true
  validates :age,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }
end
