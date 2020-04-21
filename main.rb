require './game.rb'

game_mode = 0
difficulty = 0
order_to_attack = 0

puts 'choose game mode. 1: human vs human, 2: cpu vs human, 3: cpu vs cpu'
loop do
  game_mode = gets.to_i
  break if game_mode == 1 || game_mode == 2 || game_mode == 3

  puts 'input again'
end

puts ' choose difficulty. 1 is hard. 2 is easy'
loop do
  difficulty = gets.to_i
  break if difficulty == 1 || difficulty == 2

  puts 'input again'
end
if game_mode == 2
  puts 'you choose game mode 2, choose order to attack. 0 is o first, 1 is second'
  loop do
    order_to_attack = gets.to_i
    break if order_to_attack == 1 || order_to_attack == 2

    puts 'input again'
  end
end

Game.new(game_mode: game_mode, difficulty: difficulty, order_to_attack: order_to_attack)