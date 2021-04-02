class HomeController < ApplicationController
  def index
    current_customer.plan = Enrollment.find_customer_plan(current_customer.token)

    categories = current_customer.plan.categories.map(&:id)

    @video_classes = onlive_video_classes(categories)
  rescue NoMethodError
    @plans = Plan.all
  end

  private

  def onlive_video_classes(categories)
    current_time = Time.zone.now

    VideoClass.where('category_id IN (?) AND' \
                     '? BETWEEN start_at AND end_at',
                     categories,
                     current_time)
  end
end
