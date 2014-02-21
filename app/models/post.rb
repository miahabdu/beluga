class Post < ActiveRecord::Base
  belongs_to :user

  has_many :tag_posts
  has_many :tags, through: :tag_posts
  has_many :images

  accepts_nested_attributes_for :images

  def self.tagged_with(name)
    Tag.find_by_name!(name).posts
  end

  def self.tag_counts
    Tag.select("tags.*, count(tag_posts.tag_id) as count").
      joins(:cad_taggings).group("tag_posts.tag_id")
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end

end
