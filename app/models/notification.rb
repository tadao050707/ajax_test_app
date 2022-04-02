class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :user, optional: true
  belongs_to :comment, optional: true
  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true

  scope :status_search, ->(para) { where(status: para) }

  # comment_ids = Notification.where(visitor_id: current_user.id).pluck(:user_id)
  # scope :current_user_seach, ->(notifications) { notifications.where(user_id: current_user.id).or(notifications.where(user_id: comment_ids)).or(notifications.where(action: "follow"))}

  def user_seach(notification, current_user)
    @comment_ids = Notification.where(visitor_id: current_user.id).pluck(:user_id)
    @notifications = notification.where(user_id: current_user.id).or(notification.where(user_id: @comment_ids)).or(notification.where(action: "follow"))
  end
end
