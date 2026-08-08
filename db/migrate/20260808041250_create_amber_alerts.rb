class CreateAmberAlerts < ActiveRecord::Migration[8.1]
  def change
    create_table :amber_alerts do |t|
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.string :location
      t.references :pet, null: false, foreign_key: true
      t.date :date
      t.time :time

      t.timestamps
    end
  end
end
