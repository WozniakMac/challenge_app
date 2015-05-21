class Answer < ActiveRecord::Base
  validates :contents, :presence => true
  belongs_to :question
  belongs_to :user
  has_many :likes
end
