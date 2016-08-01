class RecreateIsDeletedAsBoolean < ActiveRecord::Migration
  def change
  	remove_column :snippets, :is_deleted
  	add_column :snippets, :is_deleted, :boolean
  	remove_column :organisations, :is_deleted
  	add_column :organisations, :is_deleted, :boolean
  end
end
