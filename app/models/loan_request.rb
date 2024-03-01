# frozen_string_literal: true

class LoanRequest < ApplicationRecord
  # Lending limits: purchase price LTV cap and ARV (after-repair value) LTV cap.
  PURCHASE_PRICE_LTV = 0.9
  ARV_LTV = 0.7
  # Annual interest rate and months per year for interest expense calculation.
  ANNUAL_INTEREST_RATE = 0.13
  MONTHS_PER_YEAR = 12

  validates :address, :loan_term, :purchase_price, :repair_budget, :arv, :first_name, :email, :phone, presence: true
  validates :loan_term,
            numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 12,
                            message: 'must be between 1 and 12 months' }
  validates :purchase_price, numericality: { only_integer: true, greater_than: 0, message: 'must be a positive number' }
  validates :repair_budget, numericality: { only_integer: true, greater_than: 0, message: 'must be a positive number' }
  validates :arv, numericality: { only_integer: true, greater_than: 0, message: 'must be a positive number' }
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Returns the minimum of (90% of purchase price, 70% of ARV) per lending policy.
  def calculate_max_fundable_amount
    max_purchase_price_loan = purchase_price * PURCHASE_PRICE_LTV
    max_arv_loan = arv * ARV_LTV
    [max_purchase_price_loan, max_arv_loan].min
  end

  # Computes total interest over the loan term using annual rate and simple monthly accrual.
  def calculate_interest_expense(loan_amount)
    monthly_interest_rate = ANNUAL_INTEREST_RATE / MONTHS_PER_YEAR
    loan_amount * monthly_interest_rate * loan_term
  end

  # Profit = ARV minus funded amount and interest expense.
  def calculate_profit
    loan_amount = calculate_max_fundable_amount
    interest_expense = calculate_interest_expense(loan_amount)
    arv - loan_amount - interest_expense
  end
end
