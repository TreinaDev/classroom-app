class HomeController < ApplicationController
  def index
    @plans = if customer_signed_in?
               Plan.find_by(current_customer.token)
             else
               Plan.all
             end
  end
end
