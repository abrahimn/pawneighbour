class Rsvp < ApplicationRecord
  belongs_to :event
  belongs_to :responder, class_name: 'User'

  validates :response, presence: true
  validates :responder_id, uniqueness: { scope: event_id }
end
