class AddCoordinatesToAmberAlerts < ActiveRecord::Migration[8.1]
  def change
    add_column :amber_alerts, :latitude, :float
    add_column :amber_alerts, :longitude, :float
  end
end
