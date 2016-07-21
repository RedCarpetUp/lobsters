class AddRawDetailsToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :raw_details, :text
  end
end
