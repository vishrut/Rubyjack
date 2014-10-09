require 'Hand.rb'

# The PlayerHand class inherits from the Hand class
class PlayerHand < Hand
  attr_accessor :bet_amount
  
  # Initialize an empty hand
  def initialize
    super
    @bet_amount = 0
  end
  
  # Return the amount bet by the player on this hand
  def get_bet_amount
    return @bet_amount
  end
  
  # Add to bet amount
  def add_bet_amount(amount_added)
    @bet_amount = bet_amount + amount_added
  end
  
  # Double bet amount
  def double_bet_amount()
    add_bet_amount(@bet_amount)
  end
  
  # Clear all card from the hand, reset the points
  def clear_hand
    @hand_cards.clear
    @points = 0
  end
  
  # Return true if a hand is eligible for double down
  # Note that this does not return if a player can double down
  # since the player needs to have enough money to do that
  def valid_for_double_down
    if @hand_cards.size == 2
      return true
    else
      return false
    end
  end
  
  # Return true if a hand is eligible for a split
  # Note that this does not return if a player can split
  # since the player needs to have enough money to do that
  def valid_for_split
    if @hand_cards.size == 2
      if @hand_cards[0].symbol == @hand_cards[1].symbol
        return true
      end
    end
    return false
  end
end