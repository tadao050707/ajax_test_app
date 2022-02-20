class Users::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_normal_user, only: %i[update destroy]

  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  def ensure_normal_user
    if resource.email == 'guest@example.com' || resource.email == 'guest_admin@example.com'
      redirect_to root_path, alert: 'ゲストユーザーの編集・削除はできません。'
    end
  end

  protected
  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_update_path_for(resource)
    mypage_user_path(current_user)
  end
end
