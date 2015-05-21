class Answer < ActiveRecord::Base
  validates :contents, :presence => true
  belongs_to :question
  belongs_to :user
end
