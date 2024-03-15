# frozen_string_literal: true

class LoanRequestsController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing

  def new
    @loan_request = LoanRequest.new
  end

  def create
    @loan_request = LoanRequest.new(loan_request_params)
    if @loan_request.save
      LoanProcessorJob.perform_async(@loan_request.id)
      respond_to do |format|
        flash[:notice] = 'Loan request was successfully created.'
        format.html { redirect_to root_path }
        format.json { render json: { redirect_url: root_path, status: :ok } }
      end
    else
      respond_to do |format|
        flash[:alert] = 'Loan Request could not be saved.'
        format.html { redirect_to root_path }
        format.json do
          render json: { errors: @loan_request.errors.full_messages },
                 status: :unprocessable_entity
        end
      end
    end
  end

  private

  def loan_request_params
    params.require(:loan_request).permit(:address, :loan_term, :purchase_price, :repair_budget, :arv, :first_name,
                                         :last_name, :email, :phone)
  end

  # Return 400 Bad Request when required params are missing (e.g. JSON without loan_request key).
  def handle_parameter_missing(exception)
    respond_to do |format|
      format.html { redirect_to root_path, alert: 'Invalid request.' }
      format.json do
        render json: { errors: [exception.message] }, status: :bad_request
      end
    end
  end
end
