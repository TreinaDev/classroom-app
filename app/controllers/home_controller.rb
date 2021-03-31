class HomeController < ApplicationController
  def index
    if customer_signed_in?
      current_customer.plans = find_plans

      categories = current_customer.plans
                                   .map { |plan| plan.categories.map(&:id) }
                                   .flatten
                                   .uniq

      @video_classes = onlive_video_classes(categories)
    else
      @plans = Plan.all
    end
  end

  private

  def onlive_video_classes(categories)
    current_time = DateTime.now

    VideoClass.where('category IN (?) AND' \
                     '? BETWEEN start_at AND end_at',
                     categories,
                     current_time)
  end
end
