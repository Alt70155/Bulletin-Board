class Comment < ApplicationRecord
  belongs_to :topic

  validates :name, length: { in: 1..15 }
  validates :body, length: { in: 1..280 }
end
