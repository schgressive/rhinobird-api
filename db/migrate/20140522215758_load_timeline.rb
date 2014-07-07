class LoadTimeline < ActiveRecord::Migration
  def up
    Stream.all.each { |s| Timeline.create! resource: s, created_at: s.created_at }
    Vj.all.each { |s| Timeline.create! resource: s, created_at: s.created_at }
  end

  def down
  end
end
