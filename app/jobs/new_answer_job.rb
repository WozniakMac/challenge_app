class NewAnswerJob < ActiveJob::Base
  queue_as :default

  def perform(user, question)
    NotificationMailer.new_answer_email(user,question).deliver_later
  end
end
