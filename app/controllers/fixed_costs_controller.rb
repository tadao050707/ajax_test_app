class FixedCostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  # before_action :login_check, except: [:index]
  before_action :set_fixed_cost, only: %i[ edit update destroy ]

  def index
    @users = User.includes(:fixed_costs)
  end

  def new
    @fixed_cost = FixedCost.new
    @categories = current_user.categories.includes(:user)
  end

  def create
    @fixed_cost = current_user.fixed_costs.build(fixed_cost_params)
    if @fixed_cost.valid?
      @fixed_cost.save
      # binding.pry
      redirect_to user_path(current_user), notice: "「#{@fixed_cost.categories.map(&:cat_name).first}」を登録しました"
    else
      @categories = current_user.categories.includes(:user)
      render :new
    end
  end

  def edit
    @categories = current_user.categories.includes(:user)
  end

  def update
    @fixed_cost.update(fixed_cost_params)
    redirect_to user_path(current_user), notice: "変更しました"
    render :edit if @fixed_cost.invalid?
  end

  def destroy
    if @fixed_cost.destroy
      flash[:success] = '削除しました'
      redirect_to user_path(current_user), notice: "削除しました"
    else
      flash[:danger] = '削除に失敗しました'
      redirect_to user_path(current_user)
    end
  end


  private
  def fixed_cost_params
    params.require(:fixed_cost).permit(:payment, :content, :monthly_annual, :category_ids, :user_id)
  end

  def set_fixed_cost
    @fixed_cost = current_user.fixed_costs.find(params[:id])
  end

  def login_check
    unless user_signed_in?
      flash[:alert] = "ログインしてください"
      redirect_to root_path
    end
  end
end
