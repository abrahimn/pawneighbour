class Pet < ApplicationRecord
  belongs_to :user
  has_many_attached :photos
  has_many :listings, dependent: :destroy
  has_many :amber_alerts, dependent: :destroy
  validates :name, :age, presence: true
  validates :species, presence: true
  validates :age,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }
end
