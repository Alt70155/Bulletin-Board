class Topic < ApplicationRecord
  has_many :comments, dependent: :destroy
end
