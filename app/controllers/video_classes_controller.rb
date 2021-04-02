class VideoClassesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :authenticate_user_or_customer!, only: %i[show scheduled]
  before_action :set_video_class, only: %i[show edit update destroy]

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

    current_customer.plans = find_customer_plans
  end

  def scheduled
    plans = Plan.find_customer_plans(current_customer.token)

    categories = plans.map(&:categories)
                      .flatten
                      .uniq(&:id)

    current_time = Time.zone.now

    @video_classes_hash = {}
    categories.each do |category|
      @video_classes_hash[category.name] = VideoClass.where(category_id: category.id)
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

  def destroy
    @video_class.destroy

    flash[:notice] = 'Aula apagada com sucesso!'
    redirect_to user_root_path(current_user)
  end

  def watch
    set_video_class

    current_customer.plans = find_customer_plans
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
