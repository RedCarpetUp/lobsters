class AddRawBodyToCollcomments < ActiveRecord::Migration
  def change
  	add_column :collcomments, :raw_body, :text
  end
end
