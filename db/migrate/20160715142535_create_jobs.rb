class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :company_name
      t.string :intro
      t.text :desc
      t.text :skills_reqs
      t.text :about_company
      t.integer :pay
      t.string :location
      t.string :req_subs
      t.timestamps
    end
  end
end