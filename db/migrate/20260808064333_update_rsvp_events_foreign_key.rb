class UpdateRsvpEventsForeignKey < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :rsvps, column: :event_id
    add_foreign_key :rsvps, :events, column: :event_id
  end
end
