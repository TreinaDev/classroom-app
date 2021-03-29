class VideoClassesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  before_action :authenticate_user_or_customer!, only: %i[show]

  def new
    @categories = Category.all
    @video_class = VideoClass.new
  end

  def create
    @video_class = VideoClass.new(video_class_params)

    @video_class.user = current_user

    if @video_class.save
      redirect_to @video_class
    else
      @categories = Category.all
      render 'new'
    end
  end

  def show
    @video_class = VideoClass.find(params[:id])
    return [] unless customer_signed_in?

    @plans = Plan.find_customer_plans(current_customer.token)
  end

  private

  def video_class_params
    params.require(:video_class).permit(:name, :description,
                                        :video_url, :start_at,
                                        :end_at, :category)
  end
end
