module NotificationsHelper
  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end

  def user_serch2(notifications, current_user)
    comment_ids = Notification.where(visitor_id: current_user.id),pluck(:user_id)
    @notifications = notifications.where(user_id: current_user.id).or(notifications.where(user_id: comment_ids)).or(notifications.where(action: "follow"))
  end
end
