class TopicsController < ApplicationController
  def index
    @topics = Topic.all
  end

  def show
    @topic = Topic.find(params[:id])
    @comment = @topic.comments.build
    @comments = create_comments_hash
    session[:topic_id] = @topic.id
  end

  def new
    @topic = Topic.new
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def create
    topic = Topic.new(topic_params)
    topic.save!
    redirect_to topics_url, notice: "スレッド「#{topic.title}」を投稿しました。"
  end

  def update
    topic = Topic.find(params[:id])
    topic.update!(topic_params)
    redirect_to topics_url, notice: "スレッド「#{topic.title}」を更新しました。"
  end

  def destroy
    topic = Topic.find(params[:id])
    topic.destroy
    redirect_to topics_url, notice: "スレッド「#{topic.title}」を削除しました。"
  end

  private

    def topic_params
      params.require(:topic).permit(:title)
    end

  # private
end
