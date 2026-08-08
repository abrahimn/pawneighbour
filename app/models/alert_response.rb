class AlertResponse < ApplicationRecord
  belongs_to :spotter, class_name: 'User'
  belongs_to :amber_alert
  validates :location, presence: true
  validates :date, presence: true
  validates :time, presence: true
end
