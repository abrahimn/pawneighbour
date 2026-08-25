class CreateListingPets < ActiveRecord::Migration[8.1]
  def change
    create_table :listing_pets do |t|
      t.references :listing, null: false, foreign_key: true
      t.references :pet,     null: false, foreign_key: true
      t.timestamps
    end
  end
end
