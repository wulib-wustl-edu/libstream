class Resource < ApplicationRecord
  validates :title, presence: true,
            length: { maximum: 50 }
  validates :item_id, presence: true, length: {maximum: 6}
  validates :instructor, presence: true, length: {maximum: 50}
end
