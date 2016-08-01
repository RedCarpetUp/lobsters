class RemoveAddFieldsToSnippets < ActiveRecord::Migration
  def change
  	remove_column :snippets, :lastweek
  	remove_column :snippets, :thisweek
  	add_column :snippets, :note, :text
  end
end
