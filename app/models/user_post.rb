class UserPost < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  before_save :change_date_format

  VALID_URL_REGEX = /\A(https*\:\/\/\"?([\-_\.\!\~\*\'\(\)a-z0-9\;\/\?\:@&=\+\$\,\%\#])*)+(jpg|jpeg|gif|png)\z|(\A\z)/i

  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, length: { maximum: 200 }, format: { with: VALID_URL_REGEX }
  validates :category, presence: true, inclusion: { in: %w(日記 動物 旅行 スポーツ 音楽 アイドル 写真 その他) }
  validates :invisible, inclusion: { in: [true, false] }
  validates :release_date, presence: true

  private

    def change_date_format
      self.create_date = DateTime.now  if self.create_date.nil?
    end
end
