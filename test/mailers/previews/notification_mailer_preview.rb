# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
	def new_answer_email_preview
		user = User.first
    NotificationMailer.new_answer_email(user, user.questions.first)
  end

  def answer_accepted_email_preview
  	user = User.first
  	NotificationMailer.answer_accepted_email(user, user.questions.first)
  end
end
