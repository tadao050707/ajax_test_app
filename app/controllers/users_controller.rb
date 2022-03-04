class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[ show mypage edit update ]

  def mypage
    redirect_to user_path(current_user) unless current_user.id == @user.id
  end

  def show
    user = User.find(params[:id])
    @fixed_costs = user.fixed_costs.includes(user: [:categories])
    @comments = @user.comments
    @comment = @user.comments.build
    # flash.now[:notice1] = 'コメント内容を変更しました'

    # params[:monthly_view] ? @monthly_view = "true" : params[:monthly_view]
    if params[:monthly_view].nil?
      @monthly_view = "true"
    else
      @monthly_view = params[:monthly_view]
    end

    # （１）まず月額の支出だけまとめる groupは同じカテゴリをまとめる sumはまとめたカテゴリ(payment)を合計する。
    all_monthlies = @fixed_costs.joins(:categories).where(monthly_annual: 0).group("categories.cat_name").sum(:payment)
    # （２）年額の支出だけまとめる
    all_annuals = @fixed_costs.joins(:categories).where(monthly_annual: 1).group("categories.cat_name").sum(:payment)

    # 月額表示の場合
    # （２）を月額に変換
    if @monthly_view == "true"
      changed_monthlies = all_annuals.map{|key, value| [key, value/12]}.to_h
      # 上のall_annualsをchanged_monthliesにすると分かりやすい
      # （１）と（２）を合計し、月額として@costsに代入
      @costs = all_monthlies.merge(changed_monthlies){|key, v1, v2| v1 + v2}.sort_by { |_, v| v }.reverse
      #keyはカテゴリ名
    else
    # 年額表示の場合
      # （１）を年額に変換
      changed_annuals = all_monthlies.map{|key, value| [key, value*12]}.to_h
      # （１）と（２）を合計し、月額として@costsに代入
      # @costs = all_monthlies.merge(changed_annuals){|key, v1, v2| v1 + v2}.sort_by { |_, v| v }.reverse
      @costs = all_annuals.merge(changed_annuals){|key, v1, v2| v1 + v2}.sort_by { |_, v| v }.reverse

    end
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
