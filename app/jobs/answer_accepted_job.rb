class AnswerAcceptedJob < ActiveJob::Base
  queue_as :default

  def perform(user, question)
    NotificationMailer.answer_accepted_email(user,question).deliver_later
  end
end
