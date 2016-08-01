class Organisation < ActiveRecord::Base

  belongs_to :owner, class_name: "User"
  has_many :snippets
  has_and_belongs_to_many :users, :join_table => :organisations_users, foreign_key: "user_id", class_name: "User", association_foreign_key: "organisation_id"

  validates :name, presence: true, length: {minimum:5, maximum: 140}
  validates :intro, presence: true, length: {minimum:5, maximum: 140}

  private

end