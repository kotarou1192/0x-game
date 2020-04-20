require './game_rule.rb'

class ComputerPlayer
  attr_reader :mark

  def initialize(mark:, opponent_mark:)
    @mark = mark
    @opponent_mark = opponent_mark
  end

  def put(board:)
    @board = board
    if reach?
      finish
      return
    end
    if opponent_reach?
      defence
      return
    end
    x, y = attack copy_array @board.board
    @board.put_mark(mark: @mark, board_x: x, board_y: y)
  end

  private

  def reach?(board = @board.board)
    board.each_with_index do |line, index_y|
      line.each_with_index do |block, index_x|
        if block == '.'
          copied_board = copy_array(board)
          copied_board[index_y][index_x] = @mark
          return true if GameRule.new(game_board: copied_board).mark_align?(@mark)
        end
        next
      end
    end
    false
  end

  def opponent_reach?(board = @board.board)
    board.each_with_index do |line, index_y|
      line.each_with_index do |block, index_x|
        if block == '.'
          copied_board = copy_array(board)
          copied_board[index_y][index_x] = @opponent_mark
          return true if GameRule.new(game_board: copied_board).mark_align?(@opponent_mark)
        end
        next
      end
    end
    false
  end

  def defence(board = @board.board)
    board.each_with_index do |line, index_y|
      line.each_with_index do |block, index_x|
        if block == '.'
          copied_board = copy_array(board)
          copied_board[index_y][index_x] = @opponent_mark
          if GameRule.new(game_board: copied_board).mark_align?(@opponent_mark)
            @board.put_mark(mark: @mark, board_x: index_x, board_y: index_y)
            return
          end
        end
        next
      end
    end
  end

  def finish(board = @board.board)
    board.each_with_index do |line, index_y|
      line.each_with_index do |block, index_x|
        if block == '.'
          copied_board = copy_array(board)
          copied_board[index_y][index_x] = @mark
          if GameRule.new(game_board: copied_board).mark_align?(@mark)
            @board.put_mark(mark: @mark, board_x: index_x, board_y: index_y)
            return
          end
        end
        next
      end
    end
  end

  def attack(board, is_my_turn = true)
    queue = []
    enqueue(queue, board, is_my_turn)
    count = 0
    before_turn = true

    queue2 = []
    enqueue2(queue2, board, is_my_turn, count)

    until queue.empty?
      _x, _y, @marked_board, is_my_turn = queue.shift
      _x, _y, @memo_board, _is_my_turn = queue2.shift
      # print_board @marked_board
      # sleep 1

      next if game_finished?(@marked_board)
      # if GameRule.new(game_board: @marked_board).mark_align?(@mark)
      next if GameRule.new(game_board: @marked_board).mark_align?(@opponent_mark)

      count += 1 unless before_turn == is_my_turn
      before_turn = is_my_turn

      enqueue(queue, @marked_board, is_my_turn)
      enqueue2(queue2, @memo_board, is_my_turn, count)
    end
    print_board @memo_board
    search_first_turn_by_board
  end

  def search_first_turn_by_board
    @memo_board.each_with_index do |line, index|
      return [line.find_index(0), index] if line.any?(0)
    end
  end

  def enqueue(queue, board, is_my_turn)
    board.each_with_index do |line, index_y|
      line.each_with_index do |block, index_x|
        if block == '.' && is_my_turn == true
          copied_board = copy_array(board)
          copied_board[index_y][index_x] = @mark
          queue.push [index_x, index_y, copied_board, !is_my_turn]
        elsif block == '.' && is_my_turn == false
          copied_board = copy_array(board)
          copied_board[index_y][index_x] = @opponent_mark
          queue.push [index_x, index_y, copied_board, !is_my_turn]
        end
      end
    end
  end

  def enqueue2(queue, board, is_my_turn, counter)
    board.each_with_index do |line, index_y|
      line.each_with_index do |block, index_x|
        if block == '.' && is_my_turn == true
          copied_board = copy_array(board)
          copied_board[index_y][index_x] = counter
          queue.push [index_x, index_y, copied_board, !is_my_turn]
        elsif block == '.' && is_my_turn == false
          copied_board = copy_array(board)
          copied_board[index_y][index_x] = @opponent_mark
          queue.push [index_x, index_y, copied_board, !is_my_turn]
        end
      end
    end
  end

  def game_finished?(board)
    board.none? do |line|
      line.any? do |square|
        square == '.'
      end
    end
  end

  def copy_array(board)
    board.map do |line|
      line.map do |value|
        value
      end
    end
  end

  def print_board(board)
    board.each do |line|
      formatted_line = '┃'
      formatted_line += line.map do |square|
        "#{square}┃"
      end.join
      puts formatted_line
    end
  end
end
