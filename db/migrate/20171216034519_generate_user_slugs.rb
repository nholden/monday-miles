class GenerateUserSlugs < ActiveRecord::Migration[5.1]
  def change
    User.find_each do |user|
      user.update_column :slug, UserSlugGenerator.new(first_name: user.first_name, last_name: user.last_name).generate
    end
  end
end
