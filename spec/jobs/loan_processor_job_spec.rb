# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoanProcessorJob, type: :job do
  let(:loan_request) { create(:loan_request) }

  describe '#perform' do
    it 'generates PDF and sends termsheet email when loan request exists' do
      pdf_double = 'fake-pdf-bytes'
      mailer_double = instance_double(ActionMailer::MessageDelivery, deliver_now: true)

      allow_any_instance_of(described_class).to receive(:generate_pdf).with(loan_request).and_return(pdf_double)
      allow(UserMailer).to receive(:termsheet_email).with(loan_request, pdf_double).and_return(mailer_double)

      described_class.new.perform(loan_request.id)

      expect(UserMailer).to have_received(:termsheet_email).with(loan_request, pdf_double)
      expect(mailer_double).to have_received(:deliver_now)
    end

    it 'does not raise when loan request is not found and logs error' do
      allow(Rails.logger).to receive(:error)

      expect { described_class.new.perform(-1) }.not_to raise_error
      expect(Rails.logger).to have_received(:error).with(/LoanRequest not found for ID -1/)
    end

    it 're-raises after logging when PDF generation or mail fails' do
      allow_any_instance_of(described_class).to receive(:generate_pdf).and_raise(StandardError.new('PDF failed'))
      allow(Rails.logger).to receive(:error)

      expect { described_class.new.perform(loan_request.id) }.to raise_error(StandardError, 'PDF failed')
      expect(Rails.logger).to have_received(:error).with(/LoanProcessorJob failed/)
    end
  end
end
