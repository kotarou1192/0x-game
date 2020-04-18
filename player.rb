class Player
  attr_reader :mark

  def initialize(mark:, board:)
    @mark = mark
    @board = board
  end

  def put(x:, y:)
    @board.put_mark(mark: @mark, board_x: x, board_y: y)
  end
end
