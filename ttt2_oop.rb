require 'pry'

module Sayable
  def say(msg)
    puts "     #{msg}"
  end
end

class Game
  include Sayable

  WINNING_LINES = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]

  attr_accessor :winner
  def initialize
    system 'clear'
    @winner = false
    say "Hey let's play Tic Tac Toe!"
    say "What's your name?"
  end
 
  def check_winner(game, board)
    WINNING_LINES.each do |line|
    game.winner = "Player" if board.values_at(*line).count('X') == 3
    game.winner = "Computer" if board.values_at(*line).count('O') == 3
    end
    nil
  end

  def is_winner
    say "#{winner} won!"
  end

  def no_winner
    say "Cat's Game!"
  end
end


class Board
  include Sayable

  attr_accessor :board

  def initialize
    b = {}
    (1..9).each { |position| b[position] = ' ' }
    @board = b
    self.display_empty
  end

  def to_s
    @board
  end

  def display_empty
    say "     |     |     "
    say "  1  |  2  |  3  "
    say "     |     |     "
    say "-----+-----+-----"
    say "     |     |     "
    say "  4  |  5  |  6  "
    say "     |     |     "
    say "-----+-----+-----"
    say "     |     |     "
    say "  7  |  8  |  9  "
    say "     |     |     "
    say "Remember these positions"
    sleep(1.5)
  end

  def display_active(board)
    system 'clear'
    say "     |     |     "
    say "  #{board[1]}  |  #{board[2]}  |  #{board[3]}  "
    say "     |     |     "
    say "-----+-----+-----"
    say "     |     |     "
    say "  #{board[4]}  |  #{board[5]}  |  #{board[6]}  "
    say "     |     |     "
    say "-----+-----+-----"
    say "     |     |     "
    say "  #{board[7]}  |  #{board[8]}  |  #{board[9]}  "
    say "     |     |     "
  end

  def self.empty_spaces
    self.select { |k,v| v == ' '}.keys
  end

end




class Participant
  include Sayable

  attr_accessor :name
end


class Player < Participant

  def initialize(n)
    @name = n
  end

  def pick_square(board)
    begin
      say "Choose a square that isn't taken (1-9):"
      position = gets.chomp
    end until board.empty_spaces(board).include?(position.to_i)
    board[position.to_i] = "X"

  end
end

class Computer < Participant

  def initialize(n = "Larry")
    @name = n
  end

  def pick_square(game, board)
    say "Now #{name} will pick a square."
    position = game.empty_spaces(game.board).sample
    board[position] = "O"
  end

end

#---Game Start-----

game = Game.new
player_1 = Player.new(gets.chomp)
computer = Computer.new
board = Board.new



begin

  board.display_active(board.board)
  binding.pry
  player_1.pick_square(board.board)
  game.display_active_board(board.board)
  game.check_winner(game, board.board)
  computer.pick_square(game, board.board)
  game.check_winner(game, board.board)
  sleep(1)
end until game.winner || board.empty_spaces(board.board).empty?

if game.winner
  game.is_winner
else
  game.no_winner
end

