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
end
