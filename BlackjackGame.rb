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
      player = Player.new
      player.id = i
      player.money = 1000
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
    
    # Remove bankrupt players, exit if everyone is bankrupt
    remove_bankrupt_players
    if !are_active_players
      @game_io.print_end
      return
    end
    
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
    
    #@game_io.print_end_round
    
    # Start the next round
    start_round
  end
  
  # Iterates through all the players, executing their plays
  def all_play
    @players.each{ |player|
      if !player.is_bankrupt
        @game_io.print_separator
        self.play(player)
      end
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
      player.clear_hand
    }
    @dealer.clear_hand
  end
  
  # Dealer plays once all players have completed their plays
  def dealers_play
    @game_io.print_dealers_hand(dealer)
    
    if dealer.is_blackjack
      @game_io.print_msg('dealer_blackjack_1')
      return
    end
    
    if dealer.get_points == 21
      return
    end
    
    if dealer.get_points < 17
      hit(dealer)
      @game_io.print_dealers_hand(dealer)
    else
      return
    end
    
    if dealer.is_busted
      @game_io.print_msg('dealer_busted')
    else
      self.dealers_play
    end
  end
  
  # Players place their respective bets
  def players_place_bets
    @players.each { |player|
      if !player.is_bankrupt
        valid_bet = false
        until valid_bet do
          @game_io.print_player(player)
          bet_value = @game_io.input_bet_value
          valid_bet = player.make_bet(bet_value)
          if !valid_bet
            @game_io.print_msg("invalid_bet")
          end
        end
        @game_io.print_separator
      end
    }
  end
  
  # Compare hands of all players with the dealer
  def evaluate_all_hands
    @players.each { |player|
      compare_hands(player)
    }
  end
  
  # Pay the player
  def pay_player(player, amount)
    player.add_money(amount)
  end
  
  # Compares the hand of the player with that of the dealer
  def compare_hands(player)
    if player.is_split
      @game_io.print_split_separator_1
    end
    @game_io.print_vs_msg(player, dealer)
    if player.is_busted
      @game_io.print_msg('player_busted')
    elsif @dealer.is_busted && !player.is_blackjack
      pay_player(player, 2 * player.current_bet)
      @game_io.print_msg('dealer_busted')
    elsif @dealer.is_busted && player.is_blackjack
      pay_player(player, 2.5 * player.current_bet)
      @game_io.print_msg('player_blackjack')
    elsif player.is_blackjack && @dealer.is_blackjack
      pay_player(player, player.current_bet) #return bet
      @game_io.print_msg('blackjack_tie')
    elsif !(player.is_blackjack) && @dealer.is_blackjack
      @game_io.print_msg('dealer_blackjack')
    elsif player.is_blackjack && !(@dealer.is_blackjack)
      pay_player(player, 2.5 * player.current_bet)
      @game_io.print_msg('player_blackjack')
    elsif player.get_points > @dealer.get_points
      pay_player(player, 2 * player.current_bet)
      @game_io.print_msg('player_wins')
    elsif player.get_points == @dealer.get_points
      pay_player(player, player.current_bet)
      @game_io.print_msg('tie')
    elsif player.get_points < @dealer.get_points
      @game_io.print_msg('dealer_wins')
    end
    player.current_bet = 0
    @game_io.print_player(player)
    
    # If the player had a split, also compare the other hand
    if player.is_split
      compare_split_hand(player)
    else
      @game_io.print_separator
    end
  end
  
  # Compare player's second hand with that of the dealer, in case of a split
  def compare_split_hand(player)
    @game_io.print_split_vs_msg(player, dealer)
    if player.is_split_busted
      @game_io.print_msg('player_busted')
    elsif @dealer.is_busted && !player.is_split_blackjack
      pay_player(player, 2 * player.split_bet)
      @game_io.print_msg('dealer_busted')
    elsif @dealer.is_busted && player.is_split_blackjack
      pay_player(player, 2.5 * player.split_bet)
      @game_io.print_msg('player_blackjack')
    elsif player.is_split_blackjack && @dealer.is_blackjack
      pay_player(player, player.split_bet) #return bet
      @game_io.print_msg('blackjack_tie')
    elsif !(player.is_split_blackjack) && @dealer.is_blackjack
      @game_io.print_msg('dealer_blackjack')
    elsif player.is_split_blackjack && !(@dealer.is_blackjack)
      pay_player(player, 2.5 * player.split_bet)
      @game_io.print_msg('player_blackjack')
    elsif player.get_split_points > @dealer.get_points
      pay_player(player, 2 * player.split_bet)
      @game_io.print_msg('player_wins')
    elsif player.get_split_points == @dealer.get_points
      pay_player(player, player.split_bet)
      @game_io.print_msg('tie')
    elsif player.get_split_points < @dealer.get_points
      @game_io.print_msg('dealer_wins')
    end
    player.split_bet = 0
    @game_io.print_player(player)
    @game_io.print_separator
  end
  
  # Deal the cards to all players and the dealer
  def deal_cards
    @game_io.print_deal_cards
    for i in 1..2
      @players.each { |player|
        player.add_card_to_hand(@shoe.retrieve_card)
      }
      @dealer.add_card_to_hand(@shoe.retrieve_card)
    end
    @game_io.print_all_hands(@players)
  end
  
  # Executed when player calls a hit
  def hit(player)
    card = @shoe.retrieve_card
    player.add_card_to_hand(card)
  end
  
  # Executed when th player calls a hit on the second hand of a split
  def hit_split_hand(player)
    card = @shoe.retrieve_card
    player.add_card_to_split_hand(card)
  end
  
  # Splits the player's hand
  def split(player)
    @game_io.print_split_separator_1
    player.split_hand
    hit(player)
    hit_split_hand(player)
    play(player)
    @game_io.print_split_separator_2
    play_split(player)
  end
  
  # Play the second hand of the split
  def play_split(player)
    @game_io.print_split_hand(player)
    
    if player.is_split_blackjack
      @game_io.print_blackjack_msg(player)
      return
    end
    
    if player.get_split_points == 21
      return
    end
    
    # Get the action command for hit/stand/double-down
    action = @game_io.get_command(player.get_split_double_down, player.get_split)
    
    if action == "h"
      hit_split_hand(player)
    elsif action == "d"
      player.double_split_bet
      hit_split_hand(player)
    elsif action == "x"
      split(player)
    else
      return
    end
    
    if player.is_split_busted
      @game_io.print_split_hand(player)
      @game_io.print_busted_msg(player)
    elsif action == "d"
      @game_io.print_split_hand(player)
    else
      self.play_split(player)
    end
  end
  
  # Player plays the hand according this method
  def play(player)
    @game_io.print_hand(player)
    
    if player.is_blackjack
      @game_io.print_blackjack_msg(player)
      return
    end
    
    if player.get_points == 21
      return
    end
    
    # Get the action command for hit/stand/split/double-down
    action = @game_io.get_command(player.get_double_down, player.get_split)
    
    if action == "h"
      hit(player)
    elsif action == "d"
      player.double_bet
      hit(player)
    elsif action == "x"
      split(player)
      return
    else
      return
    end
    
    if player.is_busted
      @game_io.print_hand(player)
      @game_io.print_busted_msg(player)
    elsif action == "d"
      @game_io.print_hand(player)
    else
      self.play(player)
    end
  end

end

# Create a game object
game_object = BlackjackGame.new
