class MakeUserSlugNonNullable < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :slug, :string, null: false
  end
end
