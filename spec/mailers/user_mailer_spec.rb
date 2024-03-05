# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:loan_request) { create(:loan_request, email: 'borrower@example.com') }
  let(:pdf_content) { 'fake-pdf-content' }

  describe '#termsheet_email' do
    let(:mail) { described_class.termsheet_email(loan_request, pdf_content) }

    it 'sends to the loan request email' do
      expect(mail.to).to eq([loan_request.email])
    end

    it 'sets the subject' do
      expect(mail.subject).to eq('Your Term Sheet')
    end

    it 'includes the expected body text' do
      expect(mail.body.encoded).to include('Thank you for using our app')
      expect(mail.body.encoded).to include('term sheet')
    end

    it 'attaches the PDF' do
      expect(mail.attachments.size).to eq(1)
      expect(mail.attachments.first.filename).to eq('termsheet.pdf')
      expect(mail.attachments.first.body.raw_source).to eq(pdf_content)
    end
  end
end
