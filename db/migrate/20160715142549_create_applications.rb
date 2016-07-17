class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string :name
      t.string :email
      t.string :phoneno
      t.text :details
	  t.string :status
      t.timestamps
    end
  end
end
