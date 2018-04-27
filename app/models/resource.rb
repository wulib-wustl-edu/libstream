class Resource < ApplicationRecord
  has_hashids_uri salt: '1ac206225a7806', min_length: 7

  validates :title, presence: true,
            length: { maximum: 50 }
  validates :item_id, presence: true, length: {maximum: 6}
  validates :instructor, presence: true, length: {maximum: 50}

  mount_uploader :video, VideoUploader


  def to_jq_upload
    {
        "name" => read_attribute(:video),
        "size" => File.size(:video),
        # "url" => video.url,
        # "delete_url" => resource(:id => id),
        # "delete_type" => "DELETE"
    }
  end
end
