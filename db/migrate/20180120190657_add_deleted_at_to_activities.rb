class AddDeletedAtToActivities < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :deleted_at, :datetime
  end
end
