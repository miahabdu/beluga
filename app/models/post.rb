class Post < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search, against: [:title, :content, :category],
    using: {tsearch: {dictionary: "english"}},
    associated_against: {tags: :name}

  belongs_to :user

  has_many :tag_posts
  has_many :tags, through: :tag_posts
  has_many :images

  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: :all_blank

  scope :next,          -> (id) { where("id > ?", id).order("id ASC").first }
  scope :previous,      -> (id) { where("id < ?", id).order("id DESC").first }
  scope :related_posts, -> (id, c) { where("id != ?", id).where(category: c) }
  scope :featured,      -> { where(is_featured: true) }

  def self.text_search(query)
    if query.present?
      search(query)
    else
      scoped
    end
  end

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
