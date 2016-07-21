class CreateCollcomments < ActiveRecord::Migration
  def change
    create_table :collcomments do |t|
      t.text :body
      t.timestamps
    end
  end
end
