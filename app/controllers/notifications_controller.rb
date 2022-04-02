class NotificationsController < ApplicationController
  def index
    # current_userの投稿に紐づいた通知一覧
    @notifications = current_user.passive_notifications.page(params[:page]).per(20)
    # @notificationの中でまだ確認していない通知のみ(indexに一度も遷移していない)
    @notifications.where(checked: false).each do |notification|
      # notification.update_attributes(checked: true) #非奨励
      notification.update(checked: true)
    end
  end

  def destroy_all
    @notifications = current_user.passive_notifications.destroy_all
    redirect_to notifications_path
  end
end
