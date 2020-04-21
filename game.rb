require './board.rb'
require './game_state.rb'
require './player.rb'
require './game_rule.rb'
require './computer_player.rb'

class Game
  # gamemode 1: 2players, 2:single, 3:cpu_vs_cpu
  # difficulty 1:hard 2:soft
  # order_to_attack 0:first, 1 second
  def initialize(game_mode:, difficulty:, order_to_attack:)
    raise ArgumentError, '0 is first, 1 is second' if order_to_attack.negative? || order_to_attack > 1

    @board = Board.new(board_size: 3)
    @stat = GameState.new(order_to_attack)
    @order_to_attack = order_to_attack
    @difficulty = difficulty
    @judge = GameRule.new(game_board: @board.board)
    create_game_with_game_mode(game_mode)
  end

  private

  def create_game_with_game_mode(game_mode)
    if game_mode == 1
      @player1 = Player.new(mark: 'o', board: @board, game_state: @stat)
      @player2 = Player.new(mark: 'x', board: @board, game_state: @stat)
      p_vs_p
    elsif game_mode == 2
      @player1 = Player.new(mark: 'o', board: @board, game_state: @stat)
      @player2 = ComputerPlayer.new(mark: 'x', opponent_mark: @player1.mark, board: @board, game_state: @stat)
      p_vs_cpu
    else
      @player1 = ComputerPlayer.new(mark: 'o', opponent_mark: 'x', board: @board, game_state: @stat)
      @player2 = ComputerPlayer.new(mark: 'x', opponent_mark: @player1.mark, board: @board, game_state: @stat)
      cpu_v_cpu
    end
  end

  def cpu_v_cpu
    loop do
      if @stat.first_player_turn?
        @player1.put(game_board: @board.board)
      else
        @player2.put(game_board: @board.board)
      end
      @board.print_board
      puts ''
      if @judge.mark_align?('o')
        puts 'o win!'
        exit
      elsif @judge.mark_align?('x')
        puts 'x win!'
        exit
      elsif @judge.all_squares_marked?
        puts 'draw'
        exit
      end
    end
  end

  def p_vs_cpu
    @board.print_board
    x = 0
    y = 0
    loop do
      if @stat.turn % 2 == @order_to_attack
        loop do
          puts 'choose board coordinate. x:0, 1, 2, y:0, 1, 2. like this 2 1'
          x, y = gets.chomp.split
          break if x =~ /[1|2|0]/ && y =~ /[1|2|0]/

          if x =~ /[q|Q|quit|exit|]/
            puts 'bye'
            exit
          end
          puts 'try again'
        end
      end
      x = x.to_i
      y = y.to_i
      begin
        if @stat.turn % 2 == @order_to_attack
          @player1.put(x: x, y: y)
        else
          @player2.put(game_board: @board.board) if @difficulty == 1
          @player2.put_softly(game_board: @board.board) if @difficulty == 2
          puts ""
        end
      rescue ArgumentError => e
        puts e.message
        next
      end
      @board.print_board
      if @judge.mark_align?('o')
        puts 'o win!'
        exit
      elsif @judge.mark_align?('x')
        puts 'x win!'
        exit
      elsif @judge.all_squares_marked?
        puts 'draw'
        exit
      end
    end
  end

  def p_vs_p
    @board.print_board
    puts 'choose board coordinate. x:0, 1, 2, y:0, 1, 2. like this 2 1'
    x = 0
    y = 0
    loop do
      loop do
        x, y = gets.chomp.split
        break if x =~ /[1|2|0]/ && y =~ /[1|2|0]/

        puts 'try again'
      end
      x = x.to_i
      y = y.to_i
      begin
        if @stat.first_player_turn?
          @player1.put(x: x, y: y)
        else
          @player2.put(x: x, y: y)
        end
      rescue ArgumentError => e
        puts e.message
        next
      end
      @board.print_board
      if @judge.mark_align?('o')
        puts 'o win!'
        exit
      elsif @judge.mark_align?('x')
        puts 'x win!'
        exit
      elsif @judge.all_squares_marked?
        puts 'draw'
        exit
      end
    end
  end
end
