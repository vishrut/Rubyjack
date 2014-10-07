require 'Hand.rb'

# The DealerHand class inherits from the Hand class
class DealerHand < Hand

  # Clear the cards in the dealer's hand
  def clear_hand
    @hand_cards.clear
    @points = 0
  end
end