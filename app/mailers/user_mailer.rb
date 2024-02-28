class UserMailer < ApplicationMailer
  def termsheet_email(loan_request, pdf)
    attachments['termsheet.pdf'] = pdf
    mail(to: loan_request.email, subject: 'Your Term Sheet', body: 'Thank you for using our app. Here are those figures we promised.
      Please find attached your term sheet.')
  end
end
