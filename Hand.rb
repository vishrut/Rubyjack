# Hand class represents a hand which is made up of cards and the points
class Hand
  attr_accessor :hand_cards, :points
  
  # Initialize an empty hand
  def initialize
    @hand_cards = Array.new
    @points = 0
  end
  
  # Add a card to the hand
  def add_card(card)
    @hand_cards.push(card)
    update_points
  end
  
  # Remove the last card from the hand and return it. 
  # Used for the split action.
  def pop_card
    card = @hand_cards.pop
    #update_points
  end
  
  # Return total points of the hand
  def get_points
    return @points
  end
  
  # Return all the cards in the hand
  def get_hand_cards
    return @hand_cards
  end
  
  # Update the value of total points
  def update_points
    @points = 0
    ace_present = false
    @hand_cards.each { |card|
      @points = @points + card.value
      if card.value == 1
        ace_present = true
      end
    }
    if ace_present && (@points + 10 <= 21)
      @points = @points + 10
    end
  end
  
  # Return true if the hand is a blackjack
  def is_blackjack
    face = false
    ace = false
    @hand_cards.each { |card|
      if card.value == 10
        face = true
      end
      if card.value == 1
        ace = true
      end
    }
    if face && ace && (@hand_cards.size == 2)
      return true
    end
    return false
  end
  
  # Return true if the hand is a bust
  def is_bust
    self.update_points
    if @points > 21
      return true
    else
      return false
    end
  end
end