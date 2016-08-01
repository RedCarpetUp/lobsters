class CreateSnippets < ActiveRecord::Migration
  def change
    create_table :snippets do |t|
    	t.text :lastweek
    	t.text :thisweek
    	t.integer :is_deleted
    	t.timestamps
    end
  end
end
