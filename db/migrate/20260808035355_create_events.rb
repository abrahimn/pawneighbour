class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.references :organiser, null: false, foreign_key: { to_table: :users }
      t.string :name
      t.string :location
      t.time :time
      t.date :date
      t.text :details
      t.string :photo_url

      t.timestamps
    end
  end
end
