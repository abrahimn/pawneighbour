class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  has_one_attached :avatar

  has_many :pets, dependent: :destroy
  has_many :listings, through: :pets
  has_many :offers, dependent: :destroy

  has_many :events,
           class_name: "Event",
           foreign_key: "organiser_id"

  has_many :rsvps,
           class_name: "Rsvp",
           foreign_key: "responder_id",
           dependent: :destroy

  has_many :sent_connections,
           class_name: "Connection",
           foreign_key: "sender_id",
           dependent: :destroy

  has_many :received_connections,
           class_name: "Connection",
           foreign_key: "receiver_id",
           dependent: :destroy

  has_many :amber_alerts,
           class_name: "AmberAlert",
           foreign_key: "creator_id",
           dependent: :destroy

  has_many :amber_responses,
           class_name: "AlertResponse",
           foreign_key: "spotter_id",
           dependent: :destroy
end
