class AmberAlert < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :pet
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
  has_many :alert_responses, dependent: :destroy
  validates :location, presence: true
  validates :date, presence: true
end
