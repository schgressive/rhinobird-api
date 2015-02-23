class AddMobileSignupFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mobile_signup, :boolean
  end
end
