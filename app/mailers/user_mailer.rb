class UserMailer < ApplicationMailer
  def delete_account email
    mail to: email, subject: t("user_mailer.delete_account.info")
  end
end
