# The Shoe class. A shoe is made up of multiple decks and then shuffled.
class Shoe
  attr_accessor :size, :cards
  
  # Initialize a shoe with the size number of decks
  def initialize(size)
    @size = size
    @cards = Array.new
    for i in 1..@size
      deck = Deck.new
      @cards.concat(deck.get_cards)
    end
    
    # Shuffle all the cards in the deck
    @cards = @cards.shuffle
  end
  
  # Print all the cards in the shoe
  def print_shoe
    for i in 0..@cards.size-1
      puts "#{@cards[i].symbol} #{@cards[i].suit}"
    end
  end
  
  # Take a card out from the shoe and return it
  def retrieve_card
    card = @cards.pop
    if card.nil?
      self.reset_shoe
      card = @cards.pop
    end
    return card
  end
  
  # Reset the shoe
  def reset
    for i in 1..@size
      deck = Deck.new
      @cards.concat(deck.get_cards)
    end
    @cards = @cards.shuffle
  end
end