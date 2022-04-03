class NotificationsController < ApplicationController
  include NotificationsHelper

  def index
    # current_userの投稿に紐づいた通知一覧
    @notifications = current_user.passive_notifications
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
    # 自分がコメントした人の固定支出のIDを取ってくる
    comment_ids = Notification.where(visitor_id: current_user.id).pluck(:user_id)
    @notifications = @notifications.user_seach(@notifications, current_user, comment_ids).page(params[:page]).per(10) #リファクタ
  end

  def destroy_all
    @notifications = current_user.passive_notifications.destroy_all
    redirect_to notifications_path
  end
end
