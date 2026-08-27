class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :location, presence: true
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?

  has_one_attached :avatar

  has_many :pets, dependent: :destroy
  has_many :listings, dependent: :destroy
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

  def connections
    Connection.involving(self)
  end

  def neighbour_ids
    connections.pluck(:sender_id, :receiver_id).flatten.uniq - [id]
  end

  def connected_with?(other)
    return false if other.nil? || other == self

    neighbour_ids.include?(other.id)
  end

  def neighbours
    User.where(id: neighbour_ids)
  end

  def mutual_neighbour_ids_with(other)
    neighbour_ids & other.neighbour_ids
  end

  def mutual_connections_with(other)
    mutual_neighbour_ids_with(other).size
  end
end
