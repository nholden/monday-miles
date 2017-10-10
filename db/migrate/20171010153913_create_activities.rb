class CreateActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :activities do |t|
      t.integer :user_id
      t.integer :strava_id
      t.string :name
      t.integer :distance
      t.integer :moving_time
      t.integer :elapsed_time
      t.integer :total_elevation_gain
      t.string :activity_type
      t.datetime :start_date
      t.integer :utc_offset
      t.float :start_lat
      t.float :start_lng
      t.float :end_lat
      t.float :end_lng
      t.string :city
      t.string :state
      t.string :country
      t.text :polyline
      t.float :elev_high
      t.float :elev_low
      t.float :average_temp

      t.timestamps
    end
    add_index :activities, :user_id
  end
end
