class AddDetailsToAmberAlerts < ActiveRecord::Migration[8.1]
  def change
    add_column :amber_alerts, :details, :text
  end
end
