class Image < ActiveRecord::Base
  belongs_to :post
  mount_uploader :filename, ImageUploader

end
