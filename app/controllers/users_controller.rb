class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[ show mypage edit update ]

  def mypage
    redirect_to user_path(current_user) unless current_user.id == @user.id
  end

  def show
    user = User.find(params[:id])
    @fixed_costs = user.fixed_costs

    @comments = @user.comments.desc_sort
    @comment = @user.comments.build

    params[:monthly_view].nil? ? @monthly_view = "true" : @monthly_view = params[:monthly_view]

    #viewから受け取ったパラメーターを年額表示にする
    @join_monthlies_cost = @fixed_costs.joins(:categories).where(monthly_annual: 1).or(@fixed_costs.joins(:categories).where(monthly_annual: 0)).group("categories.cat_name").sum(:payment)

    @join_annuals_cost = @fixed_costs.joins(:categories).where(monthly_annual: 1).or(@fixed_costs.joins(:categories).where(monthly_annual: 0)).group("categories.cat_name").sum(:payment)
    @join_annuals_cost.each { |key, value| @join_annuals_cost[key] = value * 12 }
  end

  def edit
    redirect_to user_path(@user) unless @user == current_user
  end

  def update
    if current_user.update(user_params)
      redirect_to user_path(current_user)
    else
      redirect_to edit_user_path(current_user)
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end
end
