class ChangeStreamIdDatatype < ActiveRecord::Migration
  def change
    remove_column :streams, :stream_id
    add_column :streams, :stream_id, :decimal, precision: 22
  end

end
