class FixedCost < ApplicationRecord
  validates :payment, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 9999999}
  validates :content, length: { maximum: 100, message: 'は100文字以内で登録してください' }

  belongs_to :user
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations
  # has_many :bookmarks, dependent: :destroy

  enum monthly_annual: { monthly: 0, annual: 1 }

  def payment=(value)
    value.tr!('０-９', '0-9') if value.is_a?(String)
    super(value)
  end
end
