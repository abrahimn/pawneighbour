class AddOwnerToListings < ActiveRecord::Migration[8.1]
  def up
    add_reference :listings, :user, foreign_key: true

    # backfill from the existing pet -> user chain
    execute <<~SQL
      UPDATE listings
      SET user_id = pets.user_id
      FROM pets
      WHERE pets.id = listings.pet_id
    SQL

    change_column_null :listings, :user_id, false
  end

  def down
    remove_reference :listings, :user, foreign_key: true
  end
end
