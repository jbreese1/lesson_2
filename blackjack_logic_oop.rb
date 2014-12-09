require 'pry'

#say cards were dealt in this order, left to right

cards = [["Hearts", "Ace"], ["Hearts", "5"], ["Clubs", "2"], ["Hearts", "6"]]

cards2 = [["Hearts", "2"], ["Hearts", "6"], ["Clubs", "Ace"], ["Hearts", "Ace"], ["Clubs", "9"]]

#how chris showed in the final solution for last lesson
def get_old_total(cards)
  total = 0
  value_string = cards.map { |value| value[1] }
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


#new one i did.  Calc all cards that are not aces, then add aces
def get_new_total(cards)
  total = 0
  ace = []
  value_string = cards.map { |value| value[1] }
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

def final_total(cards)
  old = get_old_total(cards)
  updated =  get_new_total(cards)
  if old > updated && old < 22
    return old
  elsif updated > old && updated < 22
    return updated
  elsif updated > 21 && old > 21
    return [updated, old].min
  elsif old < updated && updated > 22 && old < 22
    return old
  else 
    return updated
  end    
end


puts ''
puts "First set of cards are: "
cards.each { |card| puts "#{card[1]} of #{card[0]}"}
puts '-----------------'
puts "Totals for first set of cards:"
puts "Old method = #{get_old_total(cards)}"
puts "New method = #{get_new_total(cards)}"
puts "Final total is #{final_total(cards)}"
puts ''
puts ''
puts "Second set of cards are: "
cards2.each { |card| puts "#{card[1]} of #{card[0]}"}
puts '-----------------'
puts "Totals for second set of cards:"
puts "Old method = #{get_old_total(cards2)}"
puts "New method = #{get_new_total(cards2)}"
puts "Final total is #{final_total(cards2)}"
