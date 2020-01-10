class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :user_post

  validates :content, presence: true, length: { maximum: 140 }
end
