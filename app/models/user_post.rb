class UserPost < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  before_save :change_date_format

  validates :invisible, inclusion: { in: [true, false] }

  private

    def change_date_format
      self.invisible = true  if self.invisible.nil?
      self.create_date = DateTime.now  if self.create_date.nil?
      self.release_date = DateTime.now  if self.release_date.nil?
    end
end
