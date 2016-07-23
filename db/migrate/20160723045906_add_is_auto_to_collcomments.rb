class AddIsAutoToCollcomments < ActiveRecord::Migration
  def change
  	add_column :collcomments, :is_auto, :boolean
  end
end
