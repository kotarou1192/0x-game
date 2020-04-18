# frozen_string_literal: true

# Board class expresses the marubatsu game's board.
class Board
  attr_reader :board

  def initialize(board_size: 3)
    @board_size = board_size
    @board = board_size.times.map do
      board_size.times.map { |_val| '.' }
    end
  end

  def put_mark(mark:, board_x:, board_y:)
    if board_x.negative? || board_x >= @board_size
      raise ArgumentError, "board_x must be between 0 to #{@board_size - 1}"
    end
    if board_y.negative? || board_y >= @board_size
      raise ArgumentError, "board_y must be between 0 to #{@board_size - 1}"
    end

    @board[board_y][board_x] = mark
  end

  def print_board
    @board.each do |line|
      formatted_line = '┃'
      formatted_line += line.map do |square|
        "#{square}┃"
      end.join
      puts formatted_line
    end
  end
end
