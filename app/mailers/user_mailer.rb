# frozen_string_literal: true

class UserMailer < ApplicationMailer
  TERMSHEET_EMAIL_BODY = <<~BODY.strip
    Thank you for using our app. Here are those figures we promised.
    Please find attached your term sheet.
  BODY

  def termsheet_email(loan_request, pdf)
    attachments['termsheet.pdf'] = pdf
    mail(
      to: loan_request.email,
      subject: 'Your Term Sheet',
      body: TERMSHEET_EMAIL_BODY
    )
  end
end
