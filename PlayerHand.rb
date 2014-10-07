require 'Hand.rb'

# The PlayerHand class inherits from the Hand class
class PlayerHand < Hand
  attr_accessor :can_double_down, :can_split
  
  # Clear all card from the hand, reset the points
  def clear_hand
    @hand_cards.clear
    @points = 0
  end
  
  # Return true if both the card have the same type
  def get_split
    @can_split = false
    if (@hand_cards.size == 2) && (hand_cards[0].symbol == hand_cards[1].symbol)
      @can_split = true
    end 
    return @can_split
  end
  
  # Return true if a player has two cards
  def get_double_down
    @can_double_down = false
    if @hand_cards.size == 2
      @can_double_down = true
    end
    return @can_double_down
  end
end