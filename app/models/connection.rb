class Connection < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  validate :sender_and_receiver_are_different

  validates :receiver_id, uniqueness: { scope: :sender_id }
  scope :involving, ->(user) { where(sender: user).or(where(receiver: user)) }

  def other_user(user)
    user == sender ? receiver : sender
  end

  private

  def sender_and_receiver_are_different
    return if sender_id.present? && sender_id != receiver_id

    errors.add(:receiver, "cannot be the same as the sender")
  end
end
