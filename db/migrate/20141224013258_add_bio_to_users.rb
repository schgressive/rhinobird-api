class AddBioToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bio, :string
    add_attachment :users, :avatar
    add_attachment :users, :background_image
  end
end
