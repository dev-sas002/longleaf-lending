# frozen_string_literal: true

module LoanRequestHelper
  def render_steps(total_steps = 6)
    (1..total_steps).map do |step|
      content_tag(:span, "Step #{step}", class: "step-#{step} text-xs md:text-md")
    end.join.html_safe
  end
end
