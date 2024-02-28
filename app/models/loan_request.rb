# frozen_string_literal: true

class LoanRequest < ApplicationRecord
  validates :address, :loan_term, :purchase_price, :repair_budget, :arv, :first_name, :email, :phone, presence: true
  validates :loan_term,
            numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 12,
                            message: 'must be between 1 and 12 months' }
  validates :purchase_price, numericality: { only_integer: true, greater_than: 0, message: 'must be a positive number' }
  validates :repair_budget, numericality: { only_integer: true, greater_than: 0, message: 'must be a positive number' }
  validates :arv, numericality: { only_integer: true, greater_than: 0, message: 'must be a positive number' }
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def calculate_max_fundable_amount
    max_purchase_price_loan = purchase_price * 0.9
    max_arv_loan = arv * 0.7
    [max_purchase_price_loan, max_arv_loan].min
  end

  def calculate_interest_expense(loan_amount)
    monthly_interest_rate = 0.13 / 12
    loan_amount * monthly_interest_rate * loan_term
  end

  def calculate_profit
    loan_amount = calculate_max_fundable_amount
    interest_expense = calculate_interest_expense(loan_amount)
    arv - loan_amount - interest_expense
  end
end
