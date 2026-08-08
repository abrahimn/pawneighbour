class Event < ApplicationRecord
  belongs_to :organiser, class_name: 'User'
  has_many :rsvps, dependent: :destroy

  validates :name, presence: true
  validates :location, presence: true
  validates :time, presence: true
  validates :date, presence: true
end
