class HomeController < ApplicationController
  def index
    if customer_signed_in?
      @plan = Enrollment.find_customer_plan(current_customer.token)

      categories ||= @plan && @plan.categories.map(&:name).uniq

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
