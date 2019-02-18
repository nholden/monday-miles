class ChangeIntegerColumnsToBigInt < ActiveRecord::Migration[5.2]
  def change
    change_column :activities, :id, :bigint
    change_column :activities, :user_id, :bigint
    change_column :activities, :strava_id, :bigint
    change_column :activities, :distance, :bigint

    change_column :users, :id, :bigint
    change_column :users, :strava_id, :bigint
  end
end
