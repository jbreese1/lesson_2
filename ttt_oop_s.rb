require 'pry'

# two methods:
# 1. extract classes and objects from existing code
# 2. write out a description of the program.  Then extract nouns from description, and group common verbs into nouns
# goal is to understand syntax, not to get it 'right'

# What is a tic tac toe game?

# A game with two players. Start with an empty 3x3 board.  One player is X, one player is O.  
# The X player goes first.  Each player will alternate selecting empty square on the board. Until a player gets 3 squares in a row.
# If all squares are marked and nobody won, it's a tie.


class Board
  WINNING_LINES = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]

  def initialize 
    @data = {}
    (1..9).each { |position| @data[position] = Square.new(' ')}
  end

  def draw
    system 'clear'
    puts "     |     |     "
    puts "  #{@data[1]}  |  #{@data[2]}  |  #{@data[3]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{@data[4]}  |  #{@data[5]}  |  #{@data[6]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{@data[7]}  |  #{@data[8]}  |  #{@data[9]}  "
    puts "     |     |     "
  end

  def all_squares_marked?
    empty_squares.size == 0
  end

  def empty_squares 
    @data.select { |key, square| square.value == ' ' }.values
  end

  def empty_positions
    @data.select { |key, square|  square.empty?}.keys
  end

  def mark_square(position, marker)
    @data[position].value = marker
  end

  def winning_condition?(marker)
    WINNING_LINES.each do |line|
      return true if @data[line[0]].value == marker && @data[line[1]].value == marker && @data[line[2]].value == marker
    end
    false
  end

end



class Square
  attr_accessor :value

  def initialize(value)
    @value = value
  end

  def occupied?
    @value != ' '
  end

  def empty?
    @value == ' '
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :marker, :name

  def initialize(name, marker)
    @name = name
    @marker = marker
  end
end



class Game

  def initialize
    @board = Board.new
    @human = Player.new("Jim", "X")
    @computer = Player.new("Larry", "O")
    @current_player = @human
  end

  def current_player_marks_square
    if @current_player == @human
      begin
        puts "choose a position (1-9)"
        position = gets.chomp.to_i
      end until @board.empty_positions.include?(position)
    else
      position = @board.empty_positions.sample
    end
    @board.mark_square(position, @current_player.marker)
  end

  def current_player_win?
    @board.winning_condition?(@current_player.marker)
  end

  def alternate_player
    if @current_player == @human
      @current_player  = @computer
    else
      @current_player = @human
    end
  end

  def play
    @board.draw
    loop do 
      current_player_marks_square
      @board.draw
      if current_player_win?
        puts "The winner is #{@current_player.name}!"
        break
      elsif @board.all_squares_marked?
        puts "it's a tie"
      else
        alternate_player
      end
    end
    puts "bye"
  end

end

Game.new.play
