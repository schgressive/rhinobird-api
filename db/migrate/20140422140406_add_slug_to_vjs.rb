class AddSlugToVjs < ActiveRecord::Migration
  def change
    add_column :vjs, :slug, :string
    add_index :vjs, :slug, unique: true
  end
end
