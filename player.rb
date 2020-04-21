class Player
  attr_reader :mark

  def initialize(mark:, board:, game_state:)
    @mark = mark
    @board = board
    @game_state = game_state
  end

  def put(x:, y:)
    @board.put_mark(mark: @mark, board_x: x, board_y: y)
    @game_state.proceed_turn
  end
end
