class AddResolvedAtToAmberAlerts < ActiveRecord::Migration[8.1]
  def change
    add_column :amber_alerts, :resolved_at, :datetime
  end
end
