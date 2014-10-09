require 'DealerHand'

# Dealer class
class Dealer
  attr_accessor :hand
  
  # Initialize dealer with an empty hand
  def initialize
    # Initialize an empty hand for the dealer
    @hand = DealerHand.new
  end
  
  # Return the points of the hand
  def get_points
    return @hand.get_points
  end
  
  # Returns true if dealer's hand is a bust
  def is_bust
    return @hand.is_bust
  end
  
  # Clear the dealer's hand
  def clear_hand
    @hand.clear_hand
  end
  
  # Return true if the dealer has a blackjack
  def is_blackjack
    return @hand.is_blackjack
  end
  
  # Add a card to the dealer's hand
  def add_card_to_hand(card)
    @hand.add_card(card)
  end
  
  # Return the dealer's hand
  def get_hand
    return @hand
  end
  
  # Is upcard ace
  def is_upcard_ace
    if @hand.hand_cards[0].symbol == 'A'
      return true
    end
    return false
  end
end