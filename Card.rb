# This class represents a card
class Card
  attr_accessor :symbol, :value, :suit
  
  # Initialize a card with the given symbol, value and suit
  def initialize(symbol, value, suit)
    @symbol = symbol
    @value = value
    @suit = suit
  end
end