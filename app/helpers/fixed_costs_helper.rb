module FixedCostsHelper
  def find_user(user_id)
    User.find(user_id)
  end

  def monthly_payment(pay)
    pay.payment/12
  end

  def annual_payment(pay)
    pay.payment*12
  end

  def switch_annual_monthly(total_annual, total_monthly, monthly_view, fixed_cost)
    if monthly_view == "true" && fixed_cost.monthly_annual == "annual"
      total_monthly << monthly_payment(fixed_cost)
    elsif monthly_view == "true" && fixed_cost.monthly_annual == "monthly"
      total_monthly << fixed_cost.payment
    elsif monthly_view == "false" && fixed_cost.monthly_annual == "monthly"
      total_annual << annual_payment(fixed_cost)
    else
      total_annual << fixed_cost.payment
    end
    return total_annual, total_monthly
  end
end
