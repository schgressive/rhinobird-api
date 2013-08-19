class ChangeStreamState < ActiveRecord::Migration
  def up
    change_column :streams, :live, :boolean, default: true
  end

  def down
    change_column :streams, :live, :boolean, default: false
  end
end
