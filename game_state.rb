# frozen_string_literal: true

# 
class GameState
  attr_reader :turn

  def initialize
    order_of_turn rand 2
    @turn = 0
  end

  def proceed_turn
    change_turn
    @turn += 1
  end

  def first_player_turn?
    @is_first_player_turn
  end

  private

  def change_turn
    @is_first_player_turn = !@is_first_player_turn
  end

  # 0:first 1:second 2:random
  def order_of_turn(num)
    if num.zero?
      @is_first_player_turn = true
    elsif num == 1
      @is_first_player_turn = false
    end

    order_of_turn rand 2 if num > 1
  end
end
