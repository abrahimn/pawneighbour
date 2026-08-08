class AlertResponse < ApplicationRecord
  belongs_to :spotter, class_name: 'User'
  belongs_to :amber_alert
end
