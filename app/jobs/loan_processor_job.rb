# frozen_string_literal: true

class LoanProcessorJob
  include Sidekiq::Job

  def perform(loan_request_id)
    loan_request = LoanRequest.find_by(id: loan_request_id)
    unless loan_request
      Rails.logger.error("LoanProcessorJob: LoanRequest not found for ID #{loan_request_id}")
      return
    end

    pdf = generate_pdf(loan_request)
    UserMailer.termsheet_email(loan_request, pdf).deliver_now
  rescue StandardError => e
    # Log and re-raise so Sidekiq can retry the job per its retry configuration.
    Rails.logger.error("LoanProcessorJob failed for loan_request_id=#{loan_request_id}: #{e.class} - #{e.message}")
    raise
  end

  private

  def generate_pdf(loan_request)
    WickedPdf.new.pdf_from_string(
      ActionController::Base.new.render_to_string(
        template: 'loan_requests/termsheet.pdf.erb',
        layout: 'application',
        locals: { loan_request: }
      )
    )
  end
end
