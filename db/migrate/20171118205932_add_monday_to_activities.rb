class AddMondayToActivities < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :monday, :boolean
  end
end
