class FixedCostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_fixed_cost, only: %i[ edit update destroy ]

  def index
    @users = User.includes(:fixed_costs).desc_sort.page(params[:page]).per(20)
    @rankings = User.includes(:fixed_costs)

    @rankings = @rankings.where(adult_number: params[:adult_number]).where(child_number: params[:child_number]) if params[:commit] == "検索"

    @user_total_cost = {}
    @rankings.each do |user|
      total_cost = 0
      cost = user.fixed_costs.map(&:payment)
      total_cost = cost.sum
      @user_total_cost.store(user.id, total_cost)
    end
    @user_total_cost = @user_total_cost.sort_by{ |_, v| v }.to_h

  end

  def new
    @fixed_cost = FixedCost.new
    @categories = current_user.categories.includes(:user)
  end

  def create
    @fixed_cost = current_user.fixed_costs.build(fixed_cost_params)
    if @fixed_cost.valid?
      @fixed_cost.change_monthly_payment(params[:fixed_cost][:monthly_annual],params[:fixed_cost][:payment])
      @fixed_cost.save
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
      redirect_to user_path(current_user), notice: "削除しました"
    else
      flash.now[:danger] = '削除に失敗しました'
      redirect_to user_path(current_user)
    end
  end


  private
  def fixed_cost_params
    params.require(:fixed_cost).permit(:payment, :content, :monthly_annual, :category_ids, :user_id, :adult_number, :child_number)
  end

  def set_fixed_cost
    @fixed_cost = current_user.fixed_costs.find(params[:id])
  end
end
