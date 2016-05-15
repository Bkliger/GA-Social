class CommentsController < ApplicationController

  def index
      @comments = Comment.all
  end

  def new
    @comment = Comment.new(parent_id: params[:parent_id])
  end

  def create


    if params[:comment][:parent_id].to_i > 0
      parent = Comment.find_by_id(params[:comment].delete(:parent_id))

      @comment = parent.children.build(comment_params)
      @comment.user_id = current_user.id
      @comment.post_id = params[:post_id]

    else

      @comment = Comment.new(comment_params)
      @comment.user_id = current_user.id
      @comment.post_id = params[:post_id]
    end

    if @comment.save
      flash[:success] = 'Your comment was successfully added!'
      redirect_to post_path(params[:post_id])
    else
      render 'new'
    end
  end

  def edit
    @comment = Comment.find_by_id(params[:id])
    if current_user == @comment.user
      render :edit
    else
      flash[:error] = "You can only edit your own comments"
      redirect_to post_path(params[:post_id])
    end

  end




private

  def comment_params
    params.require(:comment).permit(:body,:user_id,:post_id)
  end


end
