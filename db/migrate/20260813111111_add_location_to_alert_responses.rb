class AddLocationToAlertResponses < ActiveRecord::Migration[8.1]
  def change
    add_column :alert_responses, :location, :string
  end
end
