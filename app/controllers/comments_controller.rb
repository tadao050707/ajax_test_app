class CommentsController < ApplicationController
  before_action :authenticate_user!#, only: [:create]
  before_action :set_user, only: [:create, :edit, :update]

  def create
    @comment = @user.comments.build(comment_params)
    @comment.send_user = current_user.id
    respond_to do |format|
      if @comment.save
        flash.now[:notice1] = 'コメント投稿しました'
        format.js { render :index }
      else
        format.html { redirect_to user_path(@comment), notice1: "投稿できませんでした"}
      end
    end
  end

  def edit
    @comment = @user.comments.find(params[:id])
    respond_to do |format|
      # flash.now[:notice] = 'コメント内容を変更しました'
      format.js { render :edit }
    end
  end

  def update
    @comment = @user.comments.find(params[:id])
      respond_to do |format|
        if @comment.update(comment_params)
          flash.now[:notice1] = 'コメント内容を変更しました'
          format.js { render :index }
        else
          flash.now[:notice1] = 'コメントの編集に失敗しました'
          format.js { render :edit_error }
        end
      end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      flash.now[:notice1] = 'コメントを削除しました'
      format.js { render :index }
    end
  end


  private

  def comment_params
    params.require(:comment).permit(:user_id, :content)
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
