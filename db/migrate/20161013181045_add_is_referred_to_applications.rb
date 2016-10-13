class AddIsReferredToApplications < ActiveRecord::Migration
  def change
  	add_column :applications, :is_referred, :boolean
  end
end
