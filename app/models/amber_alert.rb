class AmberAlert < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :pet
  has_many :alert_responses, dependent: :destroy
  validates :location, presence: true
  validates :date, presence: true
end
