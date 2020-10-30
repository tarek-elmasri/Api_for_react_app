class Post < ApplicationRecord
  belongs_to :user

  def accessable_by?(user)
    self.user_id==user.id || user.admin?
  end
end
