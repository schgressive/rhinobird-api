class ChangeStreamFields < ActiveRecord::Migration
  def change
    change_table :streams do |t|
      t.remove :channel_id, :url, :desc
      t.rename :title, :caption
    end
  end
end
