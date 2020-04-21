# frozen_string_literal: true

require './game_rule.rb'
require './min_max.rb'

class ComputerPlayer
  attr_reader :mark

  def initialize(mark:, opponent_mark:, board:, game_state:)
    @board = board
    @min_max = MinMax.new(player_mark: mark, opponent_mark: opponent_mark)
    @mark = mark
    @opponent_mark = opponent_mark
    @game_state = game_state
  end

  def put(game_board:)
    if @game_state.turn == 0
      x = rand(3)
      y = rand(3)
    else
      x, y = @min_max.strongest_position(game_board: game_board)
    end
    @board.put_mark(mark: @mark, board_x: x, board_y: y)
    @game_state.proceed_turn
  end

  def put_softly(game_board:)
    board = game_board
    if reach? board
      finish
      @game_state.proceed_turn
      return
    end
    if opponent_reach?
      defence
      @game_state.proceed_turn
      return
    end
    x, y = attack copy_array board
    @board.put_mark(mark: @mark, board_x: x, board_y: y)
    @game_state.proceed_turn
  end

  private

  # 以下古いアルゴリズム（難読）

  def reach?(board)
    board.each_with_index do |line, index_y|
      line.each_with_index do |block, index_x|
        if block == '.'
          copied_board = copy_array(board)
          copied_board[index_y][index_x] = @mark
          if GameRule.new(game_board: copied_board).mark_align?(@mark)
            return true
          end
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
          if GameRule.new(game_board: copied_board).mark_align?(@opponent_mark)
            return true
          end
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

      if GameRule.new(game_board: @marked_board).mark_align?(@opponent_mark)
        next
      end

      count += 1 unless before_turn == is_my_turn
      before_turn = is_my_turn

      enqueue(queue, @marked_board, is_my_turn)
      enqueue2(queue2, @memo_board, is_my_turn, count)
    end
    search_first_turn_by_board @memo_board
  end

  def search_first_turn_by_board(board)
    board.each_with_index do |line, index|
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
          unless GameRule.new(game_board: copied_board).mark_align?(@opponent_mark)
            queue.push [index_x, index_y, copied_board, !is_my_turn]
          end
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
          unless GameRule.new(game_board: copied_board).mark_align?(@opponent_mark)
            queue.push [index_x, index_y, copied_board, !is_my_turn]
          end
        end
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
end
