class RemoveAddFieldsForMarkToSnippets < ActiveRecord::Migration
  def change
  	remove_column :snippets, :note
  	add_column :snippets, :raw_body, :text
  	add_column :snippets, :body, :text
  end
end
