class Rsvp < ApplicationRecord
  belongs_to :event
  belongs_to :responder, class_name: 'User'
end
