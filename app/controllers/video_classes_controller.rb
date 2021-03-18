class VideoClassesController < ApplicationController
  before_action :authenticate_user!

  def new
    @video_class = VideoClass.new
  end

  def create
    @video_class = VideoClass.new(video_class_params)

    @video_class.user = current_user

    if @video_class.save
      redirect_to @video_class
    else
      render 'new'
    end
  end

  def show
    @video_class = VideoClass.find(params[:id])
  end

  private

  def video_class_params
    params.require(:video_class).permit(:name, :description,
                                      :video_url, :start_at,
                                      :end_at)
  end

end