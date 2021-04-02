class VideoClassesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update disable]
  before_action :authenticate_user_or_customer!, only: %i[show scheduled]
  before_action :set_video_class, only: %i[show edit update disable]

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
    return [] unless customer_signed_in?

    current_customer.plan = Enrollment.find_customer_plan(current_customer.token)
  end

  def scheduled
    plan = Enrollment.find_customer_plan(current_customer.token)

    categories = plan.class_categories
    current_time = Time.zone.now

    @video_classes_hash = {}
    categories.each do |category|
      @video_classes_hash[category.name] = VideoClass.enabled.where(category_id: category.id)
                                                     .where('start_at > ?', current_time)
    end
  end

  def edit
    @categories = Category.all
  end

  def update
    if @video_class.update(video_class_params)
      redirect_to video_class_path(@video_class)
    else
      @categories = Category.all
      render :edit
    end
  end

  def disable
    @video_class.disabled!

    flash[:notice] = 'Aula desabilitada com sucesso!'
    redirect_to user_root_path(current_user)
  end

  def watch
    set_video_class

    current_customer.plan = find_customer_plan
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
                                        :end_at, :category_id)
  end
end
