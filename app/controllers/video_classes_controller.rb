class VideoClassesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
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
    set_video_class
    return [] unless customer_signed_in?

    @plans = Plan.find_customer_plans(current_customer.token)
  end

  def edit
    @categories = Category.all
    set_video_class
  end

  def update
    set_video_class

    if @video_class.update(video_class_params)
      redirect_to video_class_path(@video_class)
    else
      @categories = Category.all
      render :edit
    end
  end

  def destroy
    set_video_class
    @video_class.destroy

    flash[:notice] = 'Aula apagada com sucesso!'
    redirect_to user_root_path(current_user)
  end

  def watch
    set_video_class

    @play = true
    @watched_class = WatchedClass.create(video_class: @video_class, customer: current_customer)

    redirect_to video_class_path(@video_class)
  end

  private

  def set_video_class
    @video_class = VideoClass.find(params[:id])
  end

  def video_class_params
    params.require(:video_class).permit(:name, :description,
                                        :video_url, :start_at,
                                        :end_at, :category)
  end
end
