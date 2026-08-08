class CreatePets < ActiveRecord::Migration[8.1]
  def change
    create_table :pets do |t|
      t.string :name
      t.string :species
      t.string :profile_pic
      t.integer :age
      t.references :user, null: false, foreign_key: true
      t.text :care_instructions

      t.timestamps
    end
  end
end
