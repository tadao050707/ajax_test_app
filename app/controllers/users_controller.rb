class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[ show mypage edit update ]
  # before_action :set_fixed_cost, only: %i[ show ]

  def mypage
    redirect_to user_path(current_user) unless current_user.id == @user.id
  end

  def show
    user = User.find(params[:id])
    # @fixed_costs = user.fixed_costs.includes(user: [:categories])
    @fixed_costs = user.fixed_costs

    @comments = @user.comments
    @comment = @user.comments.build

    # params[:monthly_view] ? @monthly_view = "true" : params[:monthly_view]
    if params[:monthly_view].nil?
      @monthly_view = "true"
    else
      @monthly_view = params[:monthly_view]
    end
    #viewから受け取ったパラメーターを年額表示にする
    # @fixed_costs = FixedCost.paymemt * 12 if parmas[:monthly_view] == false
    @join_monthlies_cost = @fixed_costs.joins(:categories).where(monthly_annual: 1).or(@fixed_costs.joins(:categories).where(monthly_annual: 0)).group("categories.cat_name").sum(:payment)

    @join_annuals_cost = @fixed_costs.joins(:categories).where(monthly_annual: 1).or(@fixed_costs.joins(:categories).where(monthly_annual: 0)).group("categories.cat_name").sum(:payment)
    @join_annuals_cost.each { |key, value| @join_annuals_cost[key] = value * 12 }

  #---------------------------
    # （１）まず月額の支出だけまとめる groupは同じカテゴリをまとめる sumはまとめたカテゴリ(payment)を合計する。
    all_monthlies = @fixed_costs.joins(:categories).where(monthly_annual: 0).group("categories.cat_name").sum(:payment)
    all_annuals = @fixed_costs.joins(:categories).where(monthly_annual: 1).group("categories.cat_name").sum(:payment)
    # 月額表示の場合
    # （２）を月額に変換
    if @monthly_view == "true"
      changed_monthlies = all_annuals.map{|key, value| [key, value/12]}.to_h
      # 上のall_annualsをchanged_monthliesにすると分かりやすい
      # （１）と（２）を合計し、月額として@costsに代入
      @costs = all_monthlies.merge(changed_monthlies){|key, v1, v2| v1 + v2}.sort_by { |_, v| v }.reverse #keyはカテゴリ名
    else
    # 年額表示の場合
      changed_annuals = all_monthlies.map{|key, value| [key, value*12]}.to_h
      # （１）と（２）を合計し、月額として@costsに代入
      # @costs = all_monthlies.merge(changed_annuals){|key, v1, v2| v1 + v2}.sort_by { |_, v| v }.reverse
      @costs = all_annuals.merge(changed_annuals){|key, v1, v2| v1 + v2}.sort_by { |_, v| v }.reverse
    end
  #-----------------------------------
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

    #追加
    # def set_fixed_cost
    #   @fixed_cost = FixedCost.find(params[:id])
    # end
end
