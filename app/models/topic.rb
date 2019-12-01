class Topic < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :title, length: { in: 1..45 }
end
