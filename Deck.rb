require 'Card.rb'

# A Deck is made up of all the 52 cards
class Deck
  attr_accessor :cards
  
  # Initialize a deck of cards
  def initialize
    values = Array[1,2,3,4,5,6,7,8,9,10,10,10,10]
    symbols = Array['A','2','3','4','5','6','7','8','9','10','J','Q','K']
    suits = ["\x03","\x04","\x05","\x06"] # ASCII values for card suits
    
    @cards = Array.new
    
    for suit in 0..suits.size-1
      for symbol in 0..symbols.size-1
        card = Card.new(symbols[symbol], values[symbol], suits[suit])
        @cards.push(card)
      end
    end
  end
  
  # Return all the cards of the deck
  def get_cards
    return @cards
  end
end