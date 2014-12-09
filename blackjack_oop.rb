require 'pry'


START_WALLET = 10000
MIN_BET = 100
MAX_BET = MIN_BET * 10 
MOVES = ["H", "S"]
MODES = ["Y", "N"]
HANDS_TO_RESHUFFLE = [1, 11, 21, 31, 41, 51, 61, 71, 81, 91, 101]
DECK_RANGE = [2, 8]


module Sayable
  def say(msg)
    puts "      #{msg}"
  end 
end

class Participant
  include Sayable

  attr_accessor :name, :cards, :total
  def initialize(n)
    @name = n
    @cards = []
    @total = 0
  end

  def get_old_total
    total = 0
    value_string = self.cards.map { |value| value[1] }
    value_string.each do |string|
      if string == "Ace"
        if total <= 10
          total += 11
        else
          total += 1
        end
      elsif string.to_i == 0
        total += 10
      else
        total += string.to_i
      end
    end
    return total
  end

  def get_new_total
    total = 0
    ace = []
    value_string = self.cards.map { |value| value[1] }
    value_string.each do |string|
      if string == "Ace"
        ace.push(string)
      else
        if string.to_i == 0
          total +=10
        else
          total += string.to_i
        end
      end
    end
    ace.count.times {
      if total < 10
        total += 11
      else
        total += 1
      end  
    }
    return total
  end

  def get_total
    self.reset_total
    old = self.get_old_total
    updated =  self.get_new_total
    if old > updated && old < 22
      self.total = old
    elsif updated > old && updated < 22
      self.total = updated
    elsif updated > 21 && old > 21
      self.total = [updated, old].min
    elsif old < updated && updated > 22 && old < 22
      self.total = old
    else 
      self.total = updated
    end    
  end

  def reset_total
    @total = 0
  end

  def reset_cards!
    @cards = []
  end

end

class Player < Participant
  attr_accessor :bet, :wallet

  def initialize(n = gets.chomp)
    super
    @bet = 0
    @wallet = START_WALLET
  end

  def make_bet
    say "You have #{wallet} in your wallet"
    say "How much would you like to bet?"
    say ''
    say "Minimum bet: #{MIN_BET}    Max bet: #{MAX_BET}."
    self.bet = gets.chomp.to_i
    if !self.bet.between?(MIN_BET, MAX_BET)        
      begin
        system 'clear'
        say "You have #{wallet} in your wallet"
        say "How much would you like to bet?"
        say ''
        say "Please enter a bet between #{MIN_BET} and #{MAX_BET}"
        self.bet = gets.chomp.to_i
      end while !self.bet.between?(MIN_BET, MAX_BET)
    end
    self.wallet -= @bet
  end

  def reset_bet
    self.bet = 0
  end

  def to_s
    say "#{name} your cards are:"
    self.cards.each { |card| say "#{card[1]} of #{card[0]}"}
    say '-----------------'
    say "Your total is: #{total}"
  end

  def make_move(cards)
    begin
      say ''
      say "#{name} you bet #{bet} on this hand."
      say "What would you like to do?"
      say ''
      say "H = Hit    S = Stay"
      move = gets.chomp.upcase
        if MOVES.include?(move) == false
          say "Please choose a valid move..."
          say ''
          say "H = Hit    S = Stay"
          move = gets.chomp.upcase
        elsif move == "H"
          cards.deal_a_card(self)
        end
    end
    self.get_total
    move  
  end


end

class Dealer < Participant
  def initialize(n = "Joe the Dealer")
    super
  end

  def to_s
    say "#{name}'s cards are:"
    self.cards.each { |card| say "#{card[1]} of #{card[0]}"}
    say '-----------------'
    say "His total is: #{total}"
  end

  def make_move(cards)
    cards.deal_a_card(self)
    self.get_total
  end

end


class Deck
  include Sayable

  SUITS = ["Hearts", "Spades", "Clubs", "Diamonds"]
  CARDS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']

  attr_accessor :universe

  def initialize
    single_deck = SUITS.product(CARDS)
    say "How many decks would you like to play with?"
    say "Please enter a number between #{DECK_RANGE[0]} and #{DECK_RANGE[1]}"
    num_of_decks = gets.chomp.to_i
    if !num_of_decks.between?(DECK_RANGE[0], DECK_RANGE[1])
      begin
        system 'clear'
        say "How many decks would you like to play with?"
        say "Please enter a number between #{DECK_RANGE[0]} and #{DECK_RANGE[1]}"
        num_of_decks = gets.chomp.to_i  
      end while !num_of_decks.between?(DECK_RANGE[0], DECK_RANGE[1])
    end
    card_universe = single_deck.dup * num_of_decks
    system 'clear'
    wait = 'Please wait while we shuffle the cards'
    say wait
    sleep(0.25)
    system 'clear'
    say wait + '.'
    sleep(0.25)
    system 'clear'
    say wait + '..'
    sleep(0.25)
    system 'clear'
    say wait + '...'
    sleep (0.25)
    @universe = card_universe.shuffle!
  end

  def deal_a_card(person)
    person.cards << self.universe.pop
  end

  def deal_opening_cards(player, dealer)
    2.times { 
      deal_a_card(player) 
      deal_a_card(dealer) 
    }
  end

  def reset_totals(player, dealer)
    player.reset_total
    dealer.reset_total
  end

  def calc_totals(player, dealer)
    player.get_total
    dealer.get_total
  end


  def display_cards(player, dealer)
    self.reset_totals(player, dealer)
    self.calc_totals(player, dealer)
    system 'clear'
    say player
    say ''
    say dealer 
  end


end


class Game
  attr_accessor :hand_num, :continue, :result

  include Sayable

  def initialize
    system 'clear'
    @hand_num = 1
    @continue = "Y"
    @result = ""
  end

    def reset_totals(player, dealer)
    player.reset_total
    dealer.reset_total
  end

  def calc_totals(player, dealer)
    player.get_total
    dealer.get_total
  end




  def display_cards(player, dealer)
    self.reset_totals(player, dealer)
    self.calc_totals(player, dealer)
    system 'clear'
    say player
    say ''
    say dealer 
  end

  def compare_totals(player, dealer)
    self.calc_totals(player, dealer)  
    if player.total < 22 && dealer.total < 22 && player.total > dealer.total
      return "Player"
    elsif dealer.total > 22
      return "Player"
    elsif player.total == dealer.total
      return "Push"
    elsif player.total > 21
      return "Bust"
    elsif player.total == 21 && player.cards.count == 2
      return "Player Natural"
    elsif dealer.total == 21 && dealer.cards.count == 2
      return "Dealer Natural"
    else
      return "Dealer"
    end    
  end

  def payout(player, dealer)
    case self.result
    when "Player Natural"
      say "#{player.name}, you have a natural Blackjack.  You won #{player.bet.to_i * 1.5}"
      player.wallet += player.bet.to_i * 2.5
    when "Dealer Natural"
      say "The dealer has natural Blackjack.  You lose!"
    when "Push"
      say "You and the dealer have the same total score.  It's a push, you get your bet back."
      player.wallet += player.bet.to_i
    when "Player"
      say "Good job!  You beat the dealer #{player.total} to #{dealer.total}!"
      player.wallet += player.bet.to_i * 2
    when "Dealer"
      say "Better luck next hand!  The dealer beat you #{dealer.total} to #{player.total}!"
    when "Bust"
      say "Busted! You went over 21.  Better luck next time!"
    end
    sleep(0.5)
  end

  def play_again?
    say "Would you like to play again?"
    say "Y = Yes, any other key will end our game."
    self.continue = gets.chomp.upcase   
  end

  def clear_all(player, dealer)
    self.reset_totals(player, dealer)
    self.hand_num +=1
    player.reset_cards!
    dealer.reset_cards!
  end

  def check_natural(player, dealer)
    if player.total == 21
      return "Player Natural"
    elsif dealer.total == 21
      return "Dealer Natural"
    elsif player.total == 21 && dealer.total ==21
      return "Push"
    else
      return "Continue"
    end    
  end

  def play
    
      say "Hey, what's your name?"
      player = Player.new
      dealer = Dealer.new
      
    begin
      if HANDS_TO_RESHUFFLE.include?(self.hand_num) 
        cards = Deck.new
      end    
      system 'clear'
      player.make_bet
      cards.deal_opening_cards(player, dealer)
      self.display_cards(player, dealer)
      self.result = check_natural(player, dealer)
        if self.result == "Continue"
          begin
            self.display_cards(player, dealer)
            player_move = player.make_move(cards)
          end while player_move == "H" && player.total < 21
          if player.total < 22
            begin
              self.display_cards(player, dealer)
              sleep(1)
              if dealer.total > 17
                break
              else
                dealer.make_move(cards)
              end
            end while dealer.total < 17           
          end
          self.result = self.compare_totals(player, dealer)
        end
      self.display_cards(player, dealer)
      self.payout(player, dealer)
      self.play_again?
      self.clear_all(player, dealer)
    end while self.continue == "Y"
  end
end


#game on!
game = Game.new.play
