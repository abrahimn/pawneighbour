class AmberAlert < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :pet
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
  has_many :alert_responses, dependent: :destroy
  validates :location, presence: true
  validates :date, presence: true
  validate :pet_belongs_to_creator

  scope :open, -> { where(resolved_at: nil) }
  scope :resolved, -> { where.not(resolved_at: nil) }

  def resolved? = resolved_at.present?

  def last_seen_at
    return date.to_fs(:long) if time.blank?

    "#{date.strftime('%-d %b')}, #{time.strftime('%-l:%M%P')}"
  end

  private

  def pet_belongs_to_creator
    return if pet.blank? || creator.blank?

    errors.add(:pet, "must be your own pet") unless pet.user_id == creator_id
  end
end
