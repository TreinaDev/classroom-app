class HomeController < ApplicationController
  def index
    if customer_signed_in?
      @plans = Plan.find_by(current_customer.token)

      categories = @plans.map do |plan|
        plan.categories.map { |category| category[:name] }
                       .flatten
                       .uniq
      end

      @video_classes = VideoClass.where(category: categories)
    else
      @plans = Plan.all
    end
  end
end
