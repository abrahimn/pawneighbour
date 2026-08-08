class CreateAlertResponses < ActiveRecord::Migration[8.1]
  def change
    create_table :alert_responses do |t|
      t.references :spotter, null: false, foreign_key: { to_table: :users }
      t.text :notes
      t.time :time
      t.date :date
      t.references :amber_alert, null: false, foreign_key: true

      t.timestamps
    end
  end
end
