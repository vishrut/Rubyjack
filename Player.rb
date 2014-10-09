require 'PlayerHand.rb'
require 'Card.rb'

# Player class represents a player. Note that Dealer and Player are separate classes
class Player
  attr_accessor :id, :money, :hands, :total_bets
  
  # Initialize a player with an empty hand
  def initialize(player_id)
    @id = player_id
    
    # Initialize an empty hands array
    @hands = Array.new
    
    @money = 1000
    @total_bets = 0
  end
  
  # Add a new hand to the player
  def add_new_hand
    hand = PlayerHand.new
    @hands.push(hand)
    return hand
  end
  
  # Get initial hand
  def get_initial_hand
    return @hands[0]
  end
  
  # Make the initial bet
  def make_initial_bet(amount)
    if amount > money || amount <= 0
      return false
    end
    
    add_new_hand
    hand = get_initial_hand
    add_bet_to_hand(hand, amount)
    
    return true
  end
  
  # Add a new hand to the player for the current round
  def add_hand(hand)
    @hands.push(hand)
  end
  
  # Adds to the bet on the hand
  def add_bet_to_hand(hand, amount)
    hand.add_bet_amount(amount)
    @total_bets = @total_bets + amount
    @money = @money - amount
  end
  
  # Get bet amount on the hand
  def get_bet_on_hand(hand)
    return hand.get_bet_amount
  end
  
  # Add the given amount to the players money
  def add_money(amount)
    @money = @money + amount.floor
  end
  
  # Return true when player is bankrupt
  def is_bankrupt
    if @money == 0
      return true
    else
      return false
    end
  end
  
  # Return true if player can double down
  def can_double_down_hand(hand)
    if hand.valid_for_double_down && (@money >= hand.get_bet_amount)
      return true
    else
      return false
    end
  end
  
  # Return true if player can split
  def can_split_hand(hand)
    if hand.valid_for_split && (@money >= hand.get_bet_amount)
      return true
    else
      return false
    end
  end
  
  # Return the points of the hand
  def get_points_on_hand(hand)
    return hand.get_points
  end
  
  # Clear the hand
  def clear_all_hands
    @hands.clear
  end
  
  # Return true if the hand is a bust
  def is_bust_hand(hand)
    return hand.is_bust
  end
  
  # Return true if the hand is a blackjack
  def is_blackjack_hand(hand)
    return hand.is_blackjack
  end
  
  # Double the value of the bet
  def double_bet_on_hand(hand)
    add_bet_to_hand(hand, hand.get_bet_amount)
  end
  
  # Add a card to the hand
  def add_card_to_hand(hand, card)
    hand.add_card(card)
  end
  
  # Returns the hands
  def get_all_hands
    return @hands
  end
  
  # Split hand
  def split_hand(hand)
    new_hand = PlayerHand.new
    new_hand.add_card(hand.pop_card)
    add_bet_to_hand(new_hand, hand.get_bet_amount)
    add_hand(new_hand)
  end
end