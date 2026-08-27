class RemovePetFromListings < ActiveRecord::Migration[8.1]
  def up
    remove_reference :listings, :pet, foreign_key: true
  end

  def down
    add_reference :listings, :pet, foreign_key: true

    execute <<~SQL
      UPDATE listings
      SET pet_id = lp.pet_id
      FROM listing_pets lp
      WHERE lp.listing_id = listings.id
    SQL

    change_column_null :listings, :pet_id, false
  end
end
