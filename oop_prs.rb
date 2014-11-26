require 'pry'

module Sayable
  def say(msg)
    puts "     #{msg}"
  end
end

module Choice
   CHOICES = {"P" => "Paper", "R" => "Rock", "S" => "Scissors"}
end

module Displayable
  include Choice
  def display_moves(p,c)
    say "#{p} you chose: #{CHOICES[p.move]}."
    say "#{c} chose: #{CHOICES[c.move]}"
  end
end

class Game
  include Displayable
  include Sayable
 
  WINNING_PAIRS = [["P", "R"], ["R", "S"], ["S", "P"]]
  
  attr_accessor :power, :count, :ties

  def initialize(p = "Y", c = 0, t = 0)
    system 'clear'
    @power = p
    @count = c
    @ties = t
    say "Let's Play Rock, Paper, Scissors!"
    say "What's your name?"
  end  

  def check_winner(p, c)
    if p.move == c.move
      self.display_moves(p,c)
      say "It's a tie."
      self.ties +=1
    elsif WINNING_PAIRS.include? [p.move, c.move]
      self.display_moves(p, c)
      say "You win!"
      p.score += 1
    else
      self.display_moves(p,c)
      say "You lost!"
      c.score +=1
    end
    @count += 1
  end

  def play_again?
    sleep(1)
    say ""
    say "Want to play again?"
    @power = gets.chomp.upcase
  end

  def display_score(p,c)
    system 'clear'
    case 
    when @count >= 1
      say "Your Score: #{p.score}"
      say "#{c}'s Score: #{c.score}"
      if self.ties == 1
        say "There has been #{ties} tie."
      else
        say "There have been #{ties} ties."
      end  
      say ""
    else
      say ""
    end
  end

end

class Participant
  include Sayable
  include Choice
  attr_accessor :name, :move, :score

  def to_s
    @name
  end

  def initialize(m, s)
    @move = m
    @score = s
  end
end


class Player < Participant
  def initialize(n)
    super("", 0)
    @name = n
  end

  def make_move_choice
    @move = ""
    until CHOICES.keys.include?(@move)
      say "Okay #{name} choose one: "
      say "R for Rock, P for Paper, S for Scissors"
       @move = gets.chomp.upcase
    end     
  end

end

class Computer < Participant
  def initialize(n = "Larry the Computer")
    super("",0)
    @name = n
  end

  def make_move_choice
    @move = CHOICES.keys.sample
  end
end


on_going_game = Game.new
player_1 = Player.new(gets.chomp)
computer = Computer.new

begin
  on_going_game.display_score(player_1, computer)

  player_1.make_move_choice
  computer.make_move_choice

  on_going_game.check_winner(player_1, computer)

  on_going_game.play_again?

end while on_going_game.power == "Y"