class NotificationsController < ApplicationController
  def index
    # current_userの投稿に紐づいた通知一覧
    @notifications = current_user.passive_notifications
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
    # 自分がコメントした人の固定支出のIDを取ってくる
    comment_ids = Notification.where(visitor_id: current_user.id).pluck(:user_id)
    @notifications = @notifications.where(user_id: current_user.id).or(@notifications.where(user_id: comment_ids)).or(@notifications.where(action: "follow")).page(params[:page]).per(10)

    # @notifications = current_user_seach(@notifications).page(params[:page]).per(10)
    # user_seach(@notifications, current_user)
  end

  def destroy_all
    @notifications = current_user.passive_notifications.destroy_all
    redirect_to notifications_path
  end
end
