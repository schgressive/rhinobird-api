class EnableFulltextToStreams < ActiveRecord::Migration
  def up
    execute "ALTER TABLE streams ENGINE=MYISAM;"
    execute "ALTER TABLE streams ADD FULLTEXT INDEX caption_fulltext (caption);"
  end

  def down
    execute "ALTER TABLE streams DROP INDEX caption_fulltext;"
    execute "ALTER TABLE streams ENGINE=InnoDB;"
  end
end
