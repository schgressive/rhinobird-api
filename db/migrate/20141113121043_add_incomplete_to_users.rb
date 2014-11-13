class AddIncompleteToUsers < ActiveRecord::Migration
  def change
    add_column :users, :incomplete_fields, :string
  end
end
