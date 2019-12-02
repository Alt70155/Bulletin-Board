class CommentsController < ApplicationController
  def create
    @topic = Topic.find(session[:topic_id])
    @comment = @topic.comments.build(comment_params)
    @comment.name = '匿名' if @comment.name.length.zero?

    if @comment.save
      flash[:success] = 'コメントを投稿しました！'
      redirect_to @topic
    else
      @comments = create_comments_hash
      render 'topics/show'
    end
  end

  def destroy
    # 親コメントが削除された場合、それへの返信コメントも削除する
    topic = Topic.find(session[:topic_id])
    comment = Comment.find(params[:id])
    reply_comment_destroy(topic, comment)
    comment.destroy
    redirect_to topic, notice: "コメントを削除しました。"
  end

  private

    def comment_params
      params.require(:comment).permit(:name, :body, :reply_path)
    end

    def reply_comment_destroy(topic, parent_comment)
      all_comments = topic.comments.all
      # 掲示板内でのコメント番号を検索
      p_comment_num = all_comments.index(parent_comment) + 1

      # 自分のコメントへの返信コメントのパスを作成する
      # 通常コメントなら自分の番号を、返信コメントならreply_path + 自分の番号
      reply_path = p_comment_num.to_s
      reply_path = "#{parent_comment.reply_path}/#{p_comment_num}" if parent_comment.reply_path.present?

      all_comments.select { |comment|
        comment.reply_path == reply_path || /#{reply_path.delete('/')}\d.*/ === comment.reply_path&.delete('/')
      }.each(&:destroy)
    end

  # private
end
