class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.integer :strava_id
      t.string :medium_profile_image_url
      t.string :large_profile_image_url
      t.string :city
      t.string :state
      t.string :country
      t.string :gender
      t.string :email
      t.string :strava_access_token

      t.timestamps
    end
  end
end
