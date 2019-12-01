class ApplicationController < ActionController::Base
  def create_comments_hash
    # コメントと番号をハッシュで関連付ける
    comment_hash = {}
    @topic.comments.all.each_with_index { |comment, i|  comment_hash.store(i + 1, comment) }
    create_sets_by_hierarchy(comment_hash)
  end

  # 返信コメントの階層ごとの集合を作成する
  def create_sets_by_hierarchy(comment_hash)
    normal_comment_list = nil
    n_lebel_reply_hash_list = []
    n = 0

    loop do
      if n.zero?
        # reply_pathがnilのもの、つまり返信でない普通のコメントの集合を"配列で"作る
        normal_comment_list = comment_hash.select { |k, v| v.reply_path.nil? }.to_a
      else
        # reply_pathがn階層の集合を"ハッシュで"作る
        tmp = comment_hash.select { |k, v| v.reply_path.present? && v.reply_path.split('/').length == n }
        # n階層目の集合がない場合は空のハッシュが帰るので、lengthが0なら終了
        tmp.length.zero? ? break : n_lebel_reply_hash_list << tmp
      end
      n += 1
    end

    # 例
    # p normal_comment_list
    #=> [[1, reply_path: nil], [2, reply_path: nil], [8, reply_path: nil]]
    # p n_lebel_reply_hash_list
    #=> [{3=>reply_path: "2", 7=>reply_path: "2"}, {4=>reply_path: "2/3", 5=>reply_path: "2/3"}, {6=>reply_path: "2/3/4"}]
    sort_correct_order_with(normal_comment_list, n_lebel_reply_hash_list)
  end

  # n階層までの返信コメントを正しい順に並び替えた配列を作成する再帰的な関数
  def sort_correct_order_with(current_comment_list, n_lebel_reply_hash_list)
    sorted_list = []
    current_comment_list.each do |comment|
      sorted_list << comment

      reply_hash_list = []
      # n階層目の返信コメがある場合、i番目のコメに返信している返信コメの集合を作る
      unless n_lebel_reply_hash_list.length.zero?
        reply_hash_list = n_lebel_reply_hash_list.first.select do |k, v|
          # comment.firstでコメントと紐付いている番号を取得
          v.reply_path.split('/').last == comment.first.to_s
        end
      end

      unless reply_hash_list.length.zero?
        # 配列上の親コメントの次に子(返信)コメントを挿入する
        reply_hash_list.to_a.each_with_index do |reply, i|
          sorted_list.insert(sorted_list.index(comment) + i + 1, reply)
        end
      end
    end

    # 先頭を削除し、返信コメントの集合が無くなったら終わり
    n_lebel_reply_hash_list.shift
    if n_lebel_reply_hash_list.length.zero?
      sorted_list
    else
      sort_correct_order_with(sorted_list, n_lebel_reply_hash_list)
    end
  end

end
