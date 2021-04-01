class HomeController < ApplicationController
  def index
    if customer_signed_in?
      @plans = Plan.find_customer_plans(current_customer.token)

      categories = @plans.map { |plan| plan.categories.map(&:name) }
                         .flatten
                         .uniq

      @video_classes = get_onlive_video_classes(categories)
    else
      @plans = Plan.all
    end
  end

  private

  def get_onlive_video_classes(categories)
    current_time = DateTime.now

    VideoClass.where('category IN (?) AND' \
                     '? BETWEEN start_at AND end_at',
                     categories,
                     current_time)
  end
end
