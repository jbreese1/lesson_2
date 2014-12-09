require 'pry'

SUITS = ["Hearts", "Spades", "Clubs", "Diamonds"]
CARDS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']
START_WALLET = 10000
MIN_BET = 100
HANDS_TO_RESHUFFLE = [1, 11, 21, 31, 41, 51, 61, 71, 81, 91, 101]
POWER_CHOICES = ["Y", "N"]
MOVES = ["H", "S"]

def say(msg)
  puts "=>     #{msg}"
end

def get_number_of_decks
  number_decks_input = gets.chomp
  begin
  if number_decks_input.to_i.to_s != number_decks_input
    say "Enter a number of decks you want to play with between 2 and 8."
    number_decks_input = gets.chomp
  elsif number_decks_input.to_i.to_s == number_decks_input && number_decks_input.to_i < 2 && number_decks_input.to_i > 8
    puts "Please enter a number of decks you want to play with between 2 and 8."
    number_decks_input = gets.chomp
  end
  end until number_decks_input.to_i.to_s == number_decks_input && number_decks_input.to_i >= 2 && number_decks_input.to_i <=8
  return number_decks_input.to_i
end

def shuffle_cards(universe)
  universe.shuffle!
end

def take_player_bet(player_wallet, minimum_bet, hand_number)
  system 'clear'
  say "This is hand number #{hand_number}.  We reshuffle the cards after 10 hands"
  say ""
  say "You have #{player_wallet} in your wallet."
  say "The minimum best is #{MIN_BET} and the maximum bet is #{MIN_BET * 10}."
  say ""
  say "How much would you like to bet?"
  player_bet = gets.chomp
  begin
  if player_bet.to_i.to_s != player_bet || player_bet.to_i < minimum_bet || player_bet.to_i > minimum_bet * 10
    say "Please enter a bet between #{MIN_BET} and #{MIN_BET * 10}"
    player_bet = gets.chomp
  end
  end until player_bet.to_i >= minimum_bet && player_bet.to_i <= minimum_bet *10
  return player_bet
end

def remove_bet_from_wallet(player_wallet, player_bet)
  player_wallet -= player_bet.to_i
  return player_wallet.to_i
end


def deal_opening_cards(universe, player_cards, dealer_cards)
  count = 0
  begin
  deal_a_card(player_cards, universe)
  deal_a_card(dealer_cards, universe)
  count +=1
  end until count == 2
end

def calculate_card_total(cards)
  value_string = cards.map { |value| value[1] }
  card_total = 0
  value_string.each do |string|
    if string == "Ace"
      if card_total <= 10
        card_total += 11
      else
        card_total += 1
      end
    elsif string.to_i == 0
      card_total += 10
    else
      card_total += string.to_i
    end
  end
  card_total
end

def deal_a_card(user_cards, universe)
  user_cards << universe.pop
end

def dealer_play(player_name, player_cards, player_total, dealer_cards, dealer_total, universe)
  display_cards(player_name, player_cards, player_total, dealer_cards, dealer_total)
  sleep(0.5)
  if player_total > 21
    dealer_total = dealer_total
  else
    display_cards(player_name, player_cards, player_total, dealer_cards, dealer_total)
    sleep(0.5)
    if dealer_total < 17
      deal_a_card(dealer_cards, universe)
    end  
  end
  return calculate_card_total(dealer_cards)
end

def check_natural_blackjack(player_total, dealer_total)
  if player_total == 21
    return "Player Natural"
  elsif dealer_total == 21
    return "Dealer Natural"
  elsif player_total ==21 && dealer_total ==21
    return "Push"
  else
    return "Continue"
  end    
end

def check_result(player_cards, player_total, dealer_total)
  if player_total < 22 && dealer_total < 22 && player_total > dealer_total
    return "Player"
  elsif dealer_total > 22
    return "Player"
  elsif player_total == dealer_total
    return "Push"
  elsif player_total > 21
    return "Bust"
  elsif player_total == 21 && player_cards.count == 2
    return "Player Natural"
  elsif dealer_total == 21 && player_cards.count == 2
    return "Dealer Natural"
  else
    return "Dealer"
  end
end

def display_cards(player_name, player_cards, player_total, dealer_cards, dealer_total)
  system 'clear'
  say "#{player_name}, your cards are:"
  player_cards.each { |card| say "#{card[1]} of #{card[0]}" }
  say "----------------------------"
  say "Your total is: #{player_total}"
  say " "
  say "The dealer's cards are: "
  dealer_cards.each { |card| say "#{card[1]} of #{card[0]}" }
  say "----------------------------"
  say "Dealer total is #{dealer_total}"
  say ""
end

def display_cards_one_hidden(player_name, player_cards, player_total, dealer_cards, dealer_total)
  system 'clear'
  say "#{player_name}, your cards are:"
  player_cards.each { |card| say "#{card[1]} of #{card[0]}" }
  say "----------------------------"
  say "Your total is: #{player_total}"
  say " "
  say "The dealer's cards are: "
  say "First card dealt down."
  say "#{dealer_cards[0][1]} of #{dealer_cards[0][0]}"
  say "----------------------------"
  say "Dealer total is unknown"
  say ""
end

def payout(player_name, result, player_total, dealer_total, player_wallet, player_bet)
  case result
  when "Player Natural"
    say "You have a natural Blackjack.  You won #{player_bet.to_i * 1.5}"
    player_wallet = player_wallet + player_bet.to_i * 2.5
  when "Dealer Natural"
    say "The dealer has natural Blackjack.  You lose!"
    player_wallet = player_wallet
  when "Push"
    say "You and the dealer have the same total score.  It's a push, you get your bet back."
    player_wallet = player_wallet + player_bet.to_i
  when "Player"
    say "Good job!  You beat the dealer #{player_total} to #{dealer_total}!"
    player_wallet = player_wallet + player_bet.to_i * 2
  when "Dealer"
    say "Better luck next hand!  The dealer beat you #{dealer_total} to #{player_total}!"
    player_wallet = player_wallet
  when "Bust"
    say "Busted! You went over 21.  Better luck next time!"
    player_wallet = player_wallet
  end
  return player_wallet
end

#-------GAME START--------------

# player_wallet = START_WALLET
# hand_number = 1

# say "Hey, what's your name?"
# player_name = gets.chomp

# say "#{player_name}, how many decks would you like to play with?"
# say "Enter a number between 2 and 8."

# number_of_decks = get_number_of_decks

# begin
#   case
#   when HANDS_TO_RESHUFFLE.include?(hand_number)
#     single_deck = SUITS.product(CARDS)
#     all_cards_in_universe = single_deck.dup * number_of_decks
#     shuffle_cards(all_cards_in_universe)
#     system 'clear'
#     say "Please wait while we shuffle all the cards."
#     sleep(2)
#   else 
#     all_cards_in_universe = all_cards_in_universe
#   end
#   player_cards = []
#   dealer_cards = []

#   player_bet = take_player_bet(player_wallet, MIN_BET, hand_number)
#   player_wallet = remove_bet_from_wallet(player_wallet,player_bet)

  deal_opening_cards(all_cards_in_universe, player_cards, dealer_cards)

  player_total = calculate_card_total(player_cards)
  dealer_total = calculate_card_total(dealer_cards)
  natural = check_natural_blackjack(player_total, dealer_total)

  binding.pry

  case natural
  when "Continue"
    begin
      player_total = calculate_card_total(player_cards)
      dealer_total = calculate_card_total(dealer_cards)
      display_cards_one_hidden(player_name, player_cards, player_total, dealer_cards, dealer_total)
      if player_total >= 21
        player_move = "S"
      else
        say "#{player_name} you bet #{player_bet} on this hand."
        say "What would you like to do?"
        say "H for Hit, S for Stay."
        player_move = gets.chomp.upcase
        if MOVES.include?(player_move) == false
          say "Please enter a valid move"
          say "H for Hit, S for Stay."
          player_move = gets.chomp.upcase
        elsif player_move == "H"
          deal_a_card(player_cards, all_cards_in_universe)
        end
      end
    end until player_move == "S"

    dealer_total = dealer_play(player_name, player_cards, player_total, dealer_cards, dealer_total, all_cards_in_universe)
    display_cards(player_name, player_cards, player_total, dealer_cards, dealer_total)
    result = check_result(player_cards, player_total, dealer_total)
    player_wallet = payout(player_name, result, player_total, dealer_total, player_wallet, player_bet)
  when "Player Natural"
    display_cards(player_name, player_cards, player_total, dealer_cards, dealer_total)
    sleep(1)
    result = natural
    player_wallet = payout(player_name, result, player_total, dealer_total, player_wallet, player_bet)
  when "Dealer Natural"
    display_cards(player_name, player_cards, player_total, dealer_cards, dealer_total)
    sleep(1)
    result = "Dealer Natural"
    player_wallet = payout(player_name, result, player_total, dealer_total, player_wallet, player_bet)
  end

  hand_number += 1

  say "#{player_name} do you want to play another hand?"
  say "Y for yes, N for no."
  power = gets.chomp.upcase
  case 
  when POWER_CHOICES.include?(power) == false
    say "#{player_name} do you want to play another hand?"
    say "Y for yes, N for no."
    power = gets.chomp.upcase
  end until POWER_CHOICES.include?(power) == true
    
end while power == "Y"
