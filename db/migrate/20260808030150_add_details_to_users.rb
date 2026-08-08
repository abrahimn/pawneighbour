class AddDetailsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :name, :string
    add_column :users, :profile_pic, :string
    add_column :users, :mobile, :string
  end
end
