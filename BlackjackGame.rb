require 'GameIO.rb'
require 'Player.rb'
require 'Dealer.rb'
require 'Shoe.rb'
require 'Deck.rb'

# The BlackjackGame class is responsible for the high level game logic.
class BlackjackGame
  attr_accessor :game_io, :player_count, :players, :dealer, :shoe

  # Initialize a new BlackJack game
  def initialize
    # All IO operations are performed via this object
    @game_io = GameIO.new
    # All the player objects are stored in an Array  
    @players = Array.new
    # Initialize players, dealers, shoe
    self.setup_game
    # Start with the first round
    self.start_round
  end
  
  # Initializes all players, dealer and a shoe
  def setup_game
    @game_io.print_instructions
    @player_count = @game_io.input_player_count
    
    # initialize all players
    for i in 1..@player_count
      player = Player.new(i)
      @players.push(player)
    end
    
    # initialize dealer
    @dealer = Dealer.new
    
    shoe_size = 1 # number of decks
    @shoe = Shoe.new(shoe_size)
  end
  
  # This method starts each round in a game.
  def start_round
    
    @game_io.print_start_round
    
    # Clear all hands and reset the shoe
    clear_hands
    @shoe.reset
    
    # Get initial bets from all players, deal cards, and start the play
    players_place_bets
    deal_cards
    all_play
    
    @game_io.print_separator
    
    # Dealer plays once all players are done
    dealers_play
    
    @game_io.print_separator
    
    # Compare all hands with the dealers hand
    evaluate_all_hands
        
    # Remove bankrupt players, exit if everyone is bankrupt
    remove_bankrupt_players
    if !are_active_players
      @game_io.print_end
      return
    end
    
    # Start the next round
    start_round
  end
  
  # Evaluates all hands of all players
  def evaluate_all_hands
    @players.each{ |player|
       self.evaluate_player_hands(player)
    }
  end
  
  # Evaluate all hands of a player
  def evaluate_player_hands(player)
    hands = player.get_all_hands
    hands.each { |hand|
      compare_with_dealer(player, hand)
    }
  end
  
  # Iterates through all the players, executing their plays
  def all_play
    @players.each{ |player|
      @game_io.print_separator
      self.play_all_hands(player)
    }
  end
  
  # Play all hands
  def play_all_hands(player)
    player_hands = player.get_all_hands
    player_hands.each_with_index { |hand, index|
      if index > 0
        @game_io.print_split_hand_msg
      end
      play(player, hand)
    }
  end
  
  # Removes bankrupt players from the players array
  def remove_bankrupt_players
    # Print all bankrupt players
    @players.each{ |player|
      if player.is_bankrupt
        @game_io.print_player_bankrupt(player)
      end
    }
    
    # Delete bankrupt players
    @players.delete_if{ |player|
      player.is_bankrupt
    }
  end
  
  # Returns true if there is even a single player who is not bankrupt, false otherwise
  def are_active_players
    count = 0
    @players.each{ |player|
      if !player.is_bankrupt
        count = count + 1
      end
    }
    if count > 0
      return true
    else
      return false
    end
  end
  
  # Clear the hands of all players and th dealer
  def clear_hands
    @players.each{ |player|
      player.clear_all_hands
    }
    @dealer.clear_hand
  end
  
  # Dealer plays once all players have completed their plays
  def dealers_play
    @game_io.print_dealers_hand(@dealer)
    
    if @dealer.is_blackjack
      @game_io.print_msg('dealer_blackjack_1')
      return
    end
    
    if @dealer.get_points == 21
      return
    end
    
    if @dealer.get_points < 17
      hit_dealer
      @game_io.print_dealers_hand(@dealer)
    else
      return
    end
    
    if @dealer.is_bust
      @game_io.print_msg('dealer_busted')
    else
      self.dealers_play
    end
  end
  
  # Players place their respective bets
  def players_place_bets
    @players.each { |player|
      valid_bet = false
      until valid_bet do
        @game_io.print_player(player)
        bet_value = @game_io.input_bet_value
        valid_bet = player.make_initial_bet(bet_value)
        if !valid_bet
          @game_io.print_msg("invalid_bet")
        end
      end
      @game_io.print_separator
    }
  end
  
  # Pay the player
  def pay_player(player, amount)
    player.add_money(amount)
  end
  
  # Compares the hand of the player with that of the dealer
  def compare_with_dealer(player, hand)
    
    player_blackjack = hand.is_blackjack
    player_bust = hand.is_bust
    player_points = hand.get_points
    
    dealer_blackjack = @dealer.is_blackjack
    dealer_bust = @dealer.is_bust
    dealer_points = dealer.get_points
    
    bet = hand.get_bet_amount
    
    @game_io.print_vs_msg(player, hand, @dealer)
    
    if player_bust
      @game_io.print_msg('player_busted')
    elsif dealer_bust && !player_bust && !player_blackjack
      pay_player(player, 2 * bet)
      @game_io.print_msg('dealer_busted')
    elsif dealer_bust && player_blackjack
      pay_player(player, 2.5 * hand.get_bet_amount)
      @game_io.print_msg('player_blackjack')
    elsif player_blackjack && dealer_blackjack
      pay_player(player, bet) #return bet
      @game_io.print_msg('blackjack_tie')
    elsif !player_blackjack && dealer_blackjack
      @game_io.print_msg('dealer_blackjack')
    elsif player_blackjack && !dealer_blackjack
      pay_player(player, 2.5 * bet)
      @game_io.print_msg('player_blackjack')
    elsif player_points > dealer_points
      pay_player(player, 2 * bet)
      @game_io.print_msg('player_wins')
    elsif player_points == dealer_points
      pay_player(player, bet)
      @game_io.print_msg('tie')
    elsif player_points < dealer_points
      @game_io.print_msg('dealer_wins')
    end

    @game_io.print_player(player)
    @game_io.print_separator
    
  end
  
  # Deal the cards to all players and the dealer
  def deal_cards
    @game_io.print_deal_cards
    for i in 1..2
      @players.each { |player|
        hand = player.get_initial_hand
        player.add_card_to_hand(hand, @shoe.retrieve_card)
      }
      @dealer.add_card_to_hand(@shoe.retrieve_card)
    end
    @game_io.print_all_hands(@players)
    @game_io.print_dealers_partial_hand(dealer)
  end
  
  # Executed when player calls a hit
  def hit(player, hand)
    card = @shoe.retrieve_card
    player.add_card_to_hand(hand, card)
  end
  
  def hit_dealer
    card = @shoe.retrieve_card
    @dealer.add_card_to_hand(card)
  end
  
  # Double down on hand
  def double_down(player, hand)
    player.double_bet_on_hand(hand)
    hit(player, hand)
  end
  
  # Split player's hand
  def split(player, hand)
    player.split_hand(hand)
  end
  
  # Player plays the hand according this method
  def play(player, hand)
    @game_io.print_hand(player, hand)
    
    if hand.hand_cards.size == 1
      hit(player, hand)
      play(player, hand)
      return
    end
    
    if player.is_blackjack_hand(hand)
      @game_io.print_blackjack_msg(player)
      return
    end
    
    if player.is_bust_hand(hand)
      @game_io.print_busted_msg(player)
      return
    end
    
    if hand.get_points == 21
      @game_io.print_21_msg(player)
      return
    end
    
    # Get the action command for hit/stand/split/double-down
    action = @game_io.get_command(player.can_double_down_hand(hand), player.can_split_hand(hand))
    
    if action == "h"
      hit(player, hand)
      play(player, hand)
    elsif action == "d"
      double_down(player, hand)
      @game_io.print_hand(player, hand)
      if player.is_bust_hand(hand)
        @game_io.print_busted_msg(player)
      end
      return
    elsif action == "x"
      # split the hand
      split(player, hand)
      # replay this hand
      play(player, hand) 
    # stand
    else 
      @game_io.print_hand(player, hand)
      return
    end
  end

end

# Create a game object
game_object = BlackjackGame.new
