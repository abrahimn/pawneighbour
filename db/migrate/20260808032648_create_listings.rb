class CreateListings < ActiveRecord::Migration[8.1]
  def change
    create_table :listings do |t|
      t.string :listing_type
      t.date :start_date
      t.references :pet, null: false, foreign_key: true
      t.date :end_date
      t.text :listing_note

      t.timestamps
    end
  end
end
