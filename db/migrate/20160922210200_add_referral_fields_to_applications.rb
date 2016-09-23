class AddReferralFieldsToApplications < ActiveRecord::Migration
  def change
  	add_column :applications, :referrer_name, :string
  	add_column :applications, :referrer_email, :string
  	add_column :applications, :referrer_phone, :string
  	add_column :jobs, :referral_incentive, :decimal
  end
end