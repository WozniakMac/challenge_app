class NotificationMailer < ActionMailer::Base
  default from: "challenge@challenge.com"

  def new_answer_email(user, question)
    @user = user
    @question = question
    mail(to: @user.email, subject: 'You have new answer')
  end
end
