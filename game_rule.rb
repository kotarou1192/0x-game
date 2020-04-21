class GameRule
  def initialize(game_board:)
    @board = game_board
  end

  def mark_align?(mark)
    @board[0].size.times.each do |x|
      return true if vartical_bingo?(x, 0, mark)
      return true if diagonal_bingo?(x, 0, mark)
    end

    @board[0].size.times.each do |y|
      return true if horizontal_bingo?(0, y, mark)
    end

    false
  end

  def all_squares_marked?
    @board.none? do |line|
      line.any? do |square|
        square == '.'
      end
    end
  end

  private

  def diagonal_bingo?(x, y, mark, count = 1)
    queue = [[x, y]]
    return false if @board[y][x] != mark

    until queue.empty?

      x, y = queue.shift

      return true if count >= @board[0].size

      # /
      unless (x - 1).negative? || (y + 1) > @board[0].size - 1
        if @board[y + 1][x - 1] == mark
          queue.push [x - 1, y + 1]
          count += 1
        end
      end
    end

    queue = [[x, y]]
    count = 1

    until queue.empty?

      x, y = queue.shift

      return true if count >= @board[0].size

      # \
      unless (x + 1) > @board[0].size - 1 || (y + 1) > @board[0].size - 1
        if @board[y + 1][x + 1] == mark
          queue.push [x + 1, y + 1]
          count += 1
        end
      end
    end

    false
  end

  def horizontal_bingo?(x, y, mark, count = 1)
    return false if @board[y][x] != mark
    return true if count >= @board[0].size

    unless (x + 1) > @board[0].size - 1
      if @board[y][x + 1] == mark
        return true if horizontal_bingo? x + 1, y, mark, count + 1
      end
    end

    false
  end

  def vartical_bingo?(x, y, mark, count = 1)
    return false if @board[y][x] != mark
    return true if count >= @board[0].size

    unless (y + 1) > @board[0].size - 1
      if @board[y + 1][x] == mark
        return true if vartical_bingo? x, y + 1, mark, count + 1
      end
    end

    false
  end
end
