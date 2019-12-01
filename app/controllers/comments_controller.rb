class CommentsController < ApplicationController
  def create
    @topic = Topic.find(session[:topic_id])
    @comment = @topic.comments.build(comment_params)
    if @comment.save
      flash[:success] = 'コメントを投稿しました！'
      redirect_to @topic
    else
      @comments = create_comments_hash
      render 'topics/show'
    end
  end

  def destroy
    topic = Topic.find(session[:topic_id])
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to topic, notice: "コメントを削除しました。"
  end

  private

    def comment_params
      params.require(:comment).permit(:name, :body, :reply_path)
    end

  # private
end
