class Comment < ApplicationRecord
  belongs_to :user
  # belongs_to :fixed_cost # test
  has_many :notifications, dependent: :destroy

  validates :content, presence: true, length: { maximum: 255, message: 'は255文字以内で登録してください' }

  # def create_notification_comment!(current_user, comment_id)
  #   # binding.pry
  #   # コメントをしている人全てを取得して、全員に通知を送る（同じ人はまとめる）。また他のコメント投稿者にも通知をする。
  #   # temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
  #   temp_ids = Comment.select(:user_id).where.not(user_id: current_user.id).distinct
  #   temp_ids.each do |temp_id|
  #     # binding.pry
  #     save_notification_comment!(current_user, comment_id, temp_id['user_id'])
  #   end
  #   # まだ誰もコメントしてない場合は、投稿者に通知を送る
  #   save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  # end
  #
  # def save_notification_comment!(current_user, comment_id, visited_id)
  #   # 複数回コメントをするかもしれないので、１つの投稿に複数回通知する
  #   notification = current_user.active_notifications.new(
  #     # post_id: id,
  #     # send_user: id,
  #     user_id: id,
  #     comment_id: comment_id,
  #     visited_id: visited_id,
  #     action: 'comment'
  #   )
  #   # 自分の投稿に対するコメントは、通知済みとする
  #   if notification.visitor_id == notification.visited_id
  #     notification.checked = true
  #   end
  #   notification.save if notification.valid?
  # end
end
