class MinMax
  def initialize(player_mark:, opponent_mark:)
    @mark = player_mark
    @opponent_mark = opponent_mark
  end

  def strongest_position(game_board:)
    pos = []
    score = -2000

    game_board.each_with_index do |line, index_y|
      line.each_with_index do |block, index_x|
        if block == '.'
          copied_board = copy_array(game_board)
          copied_board[index_y][index_x] = @mark
          now_score = min_max(copied_board)
          if score < now_score
            score = now_score
            pos = [index_x, index_y]
          end
        end
      end
    end
    pos
  end

  private

  def min_max(board, is_my_turn = false)
    return 1 if GameRule.new(game_board: board).mark_align?(@mark)
    return -1 if GameRule.new(game_board: board).mark_align?(@opponent_mark)

    children = []
    node_count = 0

    board.each_with_index do |line, index_y|
      line.each_with_index do |block, index_x|
        if block == '.' && is_my_turn
          node_count += 1
          copied_board = copy_array(board)
          copied_board[index_y][index_x] = @mark
          children.push copied_board
        elsif block == '.' && !is_my_turn
          node_count += 1
          copied_board = copy_array(board)
          copied_board[index_y][index_x] = @opponent_mark
          children.push copied_board
        end
      end
    end
    return 0 if node_count.zero?

    if is_my_turn
      max = -1
      children.each do |child|
        score = min_max(child, !is_my_turn)
        max = score if score > max
      end
      max
    else
      min = 1
      children.each do |child|
        score = min_max(child, !is_my_turn)
        min = score if score < min
      end
      min
    end
  end

  def copy_array(board)
    board.map do |line|
      line.map do |value|
        value
      end
    end
  end
end
