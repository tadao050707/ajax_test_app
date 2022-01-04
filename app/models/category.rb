class Category < ApplicationRecord
  validates :cat_name, presence: true, length: { maximum: 10, message: 'は10文字以内で登録してください' }, uniqueness: true

  belongs_to :user
  has_many :categorizations, dependent: :destroy
  has_many :fixid_costs, through: :categorizations
end
