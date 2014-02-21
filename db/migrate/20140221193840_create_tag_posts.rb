class CreateTagPosts < ActiveRecord::Migration
  def change
    create_table :tag_posts do |t|
      t.references :post
      t.references :tag
      
      t.timestamps
    end
  end
end
