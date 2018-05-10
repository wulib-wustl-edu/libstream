class Resource < ApplicationRecord
  has_hashids_uri salt: '1ac206225a7806', min_length: 7

  validates :title, presence: true,
            length: { maximum: 100 }
  validates :item_id, presence: true, length: {maximum: 6}
  validates :instructor, presence: true, length: {maximum: 50}

  mount_uploader :video, VideoUploader
  serialize :video, JSON

  def self.search(search)
    where("item_id LIKE ? OR title LIKE ? OR subtitles LIKE ? OR course_id LIKE ? OR course_name LIKE ? OR semester LIKE ? OR instructor LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
  end
end
