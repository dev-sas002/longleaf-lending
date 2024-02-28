class LoanProcessorJob
  include Sidekiq::Job

  def perform(loan_request_id)
    loan_request = LoanRequest.find_by(id: loan_request_id)
    if loan_request
      pdf = generate_pdf(loan_request)
      UserMailer.termsheet_email(loan_request, pdf).deliver_now
    else
      Rails.logger.error "LoanRequest not found for ID #{loan_request_id}"
    end
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
