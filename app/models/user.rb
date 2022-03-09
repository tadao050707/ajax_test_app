class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, password_length: 6..128

  validates :email, length: { maximum: 100, message: 'は100文字以下で登録してください' }
  validates :name, presence: true, length: { maximum: 20, message: 'は20文字以下で登録してください' }
  validates :profile, length: { maximum: 255, message: 'は255文字以下で登録してください' }
  validates :adult_number, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :child_number, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}

  has_many :fixed_costs, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_fixed_costs, through: :bookmarks, source: :fixed_cost

  mount_uploader :image, ImageUploader

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
      # user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
      # 例えば name を入力必須としているならば， user.name = "ゲスト" なども必要
    end
  end
  def self.guest_admin
    find_or_create_by!(email: 'guest_admin@example.com') do |user|
      user.admin = true
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストadminユーザー"
    end
  end


  attr_accessor :current_password

  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end
    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end
end
