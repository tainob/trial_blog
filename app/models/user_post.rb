class UserPost < ApplicationRecord
  belongs_to :user

  before_save :change_date_format

  private

    def change_date_format
      self.visible = true  if self.visible.nil?
      self.create_date = DateTime.now  if self.create_date.nil?
      self.release_date = DateTime.now  if self.release_date.nil?
    end
end
