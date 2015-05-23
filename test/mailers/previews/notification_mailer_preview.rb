# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
	def new_answer_email_preview
    NotificationMailer.new_answer_email(User.first)
  end
end
