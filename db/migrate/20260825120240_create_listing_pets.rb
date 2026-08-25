class CreateListingPets < ActiveRecord::Migration[8.1]
  def up
    create_table :listing_pets do |t|
      t.references :listing, null: false, foreign_key: true
      t.references :pet,     null: false, foreign_key: true
      t.timestamps
    end

    add_index :listing_pets, [:listing_id, :pet_id], unique: true

    execute <<~SQL
      INSERT INTO listing_pets (listing_id, pet_id, created_at, updated_at)
      SELECT id, pet_id, NOW(), NOW()
      FROM listings
      WHERE pet_id IS NOT NULL
    SQL
  end

  def down
    drop_table :listing_pets
  end
end
