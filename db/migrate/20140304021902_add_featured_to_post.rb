class AddFeaturedToPost < ActiveRecord::Migration
  def change
    add_column :posts, :is_featured, :boolean
  end
end
