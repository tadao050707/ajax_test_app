class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :fixed_cost
end
