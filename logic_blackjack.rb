DECK_RANGE = [2, 8]

num_of_decks = gets.chomp.to_i
if !num_of_decks.between?(DECK_RANGE[0], DECK_RANGE[1])
  begin
    system 'clear'
    puts "made it inside other loop"
    puts "Please enter a number between #{DECK_RANGE[0]} and #{DECK_RANGE[1]}"
    num_of_decks = gets.chomp.to_i  
  end while !num_of_decks.between?(DECK_RANGE[0], DECK_RANGE[1])
end