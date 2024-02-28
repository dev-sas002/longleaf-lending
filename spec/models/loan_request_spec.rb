# spec/models/loan_request_spec.rb
require 'rails_helper'

RSpec.describe LoanRequest, type: :model do
  subject { described_class.new }

  it "is valid with valid attributes" do
    subject.address = "123 Main St"
    subject.loan_term = 6
    subject.purchase_price = 200000
    subject.repair_budget = 30000
    subject.arv = 300000
    subject.first_name = "John"
    subject.email = "john@example.com"
    subject.phone = "1234567890"
    
    expect(subject).to be_valid
  end

  it "is not valid without required attributes" do
    expect(subject).not_to be_valid
    expect(subject.errors[:address]).to include("can't be blank")
    expect(subject.errors[:loan_term]).to include("can't be blank")
    expect(subject.errors[:purchase_price]).to include("can't be blank")
    expect(subject.errors[:repair_budget]).to include("can't be blank")
    expect(subject.errors[:arv]).to include("can't be blank")
    expect(subject.errors[:first_name]).to include("can't be blank")
    expect(subject.errors[:email]).to include("can't be blank")
    expect(subject.errors[:phone]).to include("can't be blank")
  end

  it "validates numericality of loan_term" do
    subject.loan_term = 0
    expect(subject).not_to be_valid
    expect(subject.errors[:loan_term]).to include("must be between 1 and 12 months")
  end

  it "validates numericality of purchase_price, repair_budget, and arv" do
    subject.purchase_price = 0
    subject.repair_budget = 0
    subject.arv = 0
    expect(subject).not_to be_valid
    expect(subject.errors[:purchase_price]).to include("must be a positive number")
    expect(subject.errors[:repair_budget]).to include("must be a positive number")
    expect(subject.errors[:arv]).to include("must be a positive number")
  end

  it "validates uniqueness and format of email" do
    existing_loan_request = create(:loan_request, email: "test@example.com")
    subject.email = "test@example.com"
    expect(subject).not_to be_valid
    expect(subject.errors[:email]).to include("has already been taken")

    subject.email = "invalid-email"
    expect(subject).not_to be_valid
    expect(subject.errors[:email]).to include("is invalid")
  end

  describe "#calculate_max_fundable_amount" do
    it "calculates max fundable amount correctly" do
      subject.purchase_price = 200000
      subject.arv = 300000
      expect(subject.calculate_max_fundable_amount).to eq(180000) # 200000 * 0.9
    end
  end

  describe "#calculate_interest_expense" do
    it "calculates interest expense correctly" do
      subject.purchase_price = 200000
      subject.arv = 300000
      subject.loan_term = 6
      expect(subject.calculate_interest_expense(180000)).to eq(11700)
    end
  end

  describe "#calculate_profit" do
    it "calculates profit correctly" do
      subject.purchase_price = 200000
      subject.arv = 300000
      subject.loan_term = 6

      allow(subject).to receive(:calculate_max_fundable_amount).and_return(180000)
      allow(subject).to receive(:calculate_interest_expense).with(300000).and_return(2340)

      expect(subject.calculate_profit).to eq(300000)
    end
  end
end
