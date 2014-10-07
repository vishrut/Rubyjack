require 'PlayerHand.rb'
require 'Card.rb'

# Player class represents a player. Note that Dealer and Player are separate classes
class Player
  attr_accessor :id, :money, :current_bet, :hand, :is_split, :split_hand, :split_bet
  
  # Initialize a player with an empty hand
  def initialize
    # Initialize an empty hand
    @hand = PlayerHand.new
    @is_split = false
    @split_bet = 0
  end
  
  # Get the value of current bet
  def get_current_bet
    return @current_bet
  end
  
  # Add the given amount to the players money
  def add_money(amount)
    @money = @money + amount.floor
  end
  
  # Return true when player is bankrupt
  def is_bankrupt
    if (@money == 0) && (@current_bet == 0)
      return true
    else
      return false
    end
  end
  
  # Get the value of the bet on the second hand of the split
  def get_split_bet
    return @split_bet
  end
  
  # Return true if player can double down
  def get_double_down
    if @hand.get_double_down && (@money >= current_bet)
      return true
    else
      return false
    end
  end
  
  # Return true if player can double down on second hand of the split
  def get_split_double_down
    if @split_hand.get_double_down && (@money >= current_bet)
      return true
    else
      return false
    end
  end
  
  # Split the hand into two hands
  def split_hand
    @is_split = true
    @split_bet = @current_bet
    @money = @money - @current_bet
    @split_hand = PlayerHand.new
    @split_hand.add_card(@hand.pop_card)
  end
  
  # Return true if player can split the hand
  def get_split
    if @is_split
      return false
    end
    return @hand.get_split && (@money >= current_bet)
  end
  
  # Return the points of the hand
  def get_points
    return @hand.get_points
  end
  
  # Return points of the second hand of the split
  def get_split_points
    return @split_hand.get_points
  end
  
  # Clear the hand
  def clear_hand
    @hand.clear_hand
    @is_split = false
  end
  
  # Return true if the hand is a bust
  def is_busted
    return @hand.is_bust
  end
  
  # Return true if the hand is a blackjack
  def is_blackjack
    return @hand.is_blackjack
  end
  
  # Return true if second hand of the split is a bust
  def is_split_busted
    return @split_hand.is_bust
  end
  
  # Return true if second hand of the split is a blackjack
  def is_split_blackjack
    return @split_hand.is_blackjack
  end
  
  # Make a bet of the given value
  def make_bet(bet_value)
    if bet_value > @money
      return false
    end
    
    if bet_value <= 0
      return false
    end
    
    @current_bet = bet_value
    @money = @money - @current_bet
    return true
  end
  
  # Double the value of the bet
  def double_bet
    @money = @money - @current_bet
    @current_bet = 2 * @current_bet
  end
  
  # Double the value of bet on the second hand of the split
  def double_split_bet
    @money = @money - @split_bet
    @split_bet = 2 * @split_bet
  end
  
  # Add a card to the hand
  def add_card_to_hand(card)
    @hand.add_card(card)
  end
  
  # Add a card to the second hand of the split
  def add_card_to_split_hand(card)
    @split_hand.add_card(card)
  end
  
  # Returns the hand
  def get_hand
    return @hand
  end
  
  # Returns the second hand of the split
  def get_split_hand
    return @split_hand
  end
end