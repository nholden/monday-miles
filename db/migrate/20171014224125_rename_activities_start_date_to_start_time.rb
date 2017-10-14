class RenameActivitiesStartDateToStartTime < ActiveRecord::Migration[5.1]
  def change
    rename_column :activities, :start_date, :start_time
  end
end
