class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :desc_sort, -> { order(created_at: :desc) }
end
