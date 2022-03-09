class BookmarksController < ApplicationController
  def create
    bookmark = current_user.bookmarks.create(fixed_cost_id: params[:fixed_cost_id])
    binding.pry
    redirect_to user_path(params[:fixed_cost_id]), notice: "#{bookmark.fixed_cost.user.name}さんのブログをお気に入り登録しました"
    #今見ているuserのid
  end

  def destroy
    bookmark = current_user.bookmarks.find_by(id: params[:id]).destroy
    # binding.pry
    # redirect_to user_path(user.id), notice: "#{bookmark.fixed_cost.user.name}さんのブログをお気に入り解除しました"
    redirect_to fixed_costs_path, notice: "#{bookmark.fixed_cost.user.name}さんのブログをお気に入り解除しました"
  end
end
