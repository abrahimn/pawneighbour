class CreateRsvps < ActiveRecord::Migration[8.1]
  def change
    create_table :rsvps do |t|
      t.references :event, null: false, foreign_key: { to_table: :users }
      t.references :responder, null: false, foreign_key: { to_table: :users }
      t.string :response

      t.timestamps
    end
  end
end
