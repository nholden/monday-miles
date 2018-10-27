class AddStravaRefreshTokenColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :strava_access_token_expires_at, :datetime
    add_column :users, :strava_refresh_token, :string
  end
end
