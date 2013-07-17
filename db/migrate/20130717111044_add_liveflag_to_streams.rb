class AddLiveflagToStreams < ActiveRecord::Migration
  def change
    add_column :streams, :live, :boolean, default: false
  end
end
