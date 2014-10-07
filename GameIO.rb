# The GameIO class. This class is responsible for the input/output operations of the game.
class GameIO
  attr_accessor :messages
  
  # Initialize the GameIO class 
  def initialize
    # All messages are stored in a map for convenient re-usability
    @messages = {"invalid_bet" => "Invalid bet. Your bet must be between 0 and your available amount.",
                 "input_player_count" => "Please enter the number of players.",
                 "input_shoe_size" => "Please enter the number of decks.",
                 "instructions" => "Game instructions go here.",
                 "make_bet" => "Please enter the bet amount.",
                 "hit_or_stay" => "Enter s to stand, or h to hit.",
                 "dealer_blackjack_1" => "Dealer has blackjack!",
                 "dealer_busted" => "Dealer busted!",
                 "blackjack_tie" => "Dealer and player both have a blackjack. Bet pushed back.",
                 "player_blackjack" => "Player has a blackjack, dealer does not. Player wins.",
                 "dealer_blackjack" => "Dealer has a blackjack, player does not. Dealer wins",
                 "player_wins" => "Player wins.",
                 "dealer_wins" => "Dealer wins.",
                 "tie" => "Tie! Bet pushed back.",
                 "player_busted" => "Player busted. Player loses the bet.",
                 "dealer_busted" => "Dealer busted.",
                 "round_complete" => "ROUND COMPLETE.",
                 "round_begin" => "NEW ROUND BEGINS.",
                 "invalid_command" => "Please enter a valid command.",
                 "can_double_down" => "Enter d to double down.",
                 "can_split" => "Enter x to split."
                 }
  end
  
  # Prints the message based on id given
  def print_msg(message_id)
    puts @messages[message_id]
  end
  
  # Print game instructions
  def print_instructions
    self.print_msg("instructions")
  end
  
  # Get the player count from the input
  def input_player_count
    valid_input = false
    until valid_input do
      self.print_msg("input_player_count")
      player_count = gets.chomp.to_i
      if player_count > 0
        valid_input = true
      end
    end
    return player_count
  end
  
  # Get the number of decks from the input, currently not in use
  def input_shoe_size
    self.print_msg("input_shoe_size")
    shoe_size = gets.chomp.to_i
    return shoe_size
  end
  
  # Print at start of round
  def print_start_round
    print_separator
    print_msg('round_begin')
    print_separator
  end
  
  # Print at end of round
  def print_end_round
    print_separator_strong
    print_msg('round_complete')
    print_separator_strong
  end
  
  # Get the bet value from the input 
  def input_bet_value
    self.print_msg("make_bet")
    bet_value = gets.chomp.to_i
    return bet_value
  end
  
  # Print details of all players
  def print_all_players(players)
    players.each {|player|
      print_player(player)
    }
  end
  
  # Print details of a player
  def print_player(player)
    puts "Player #{player.id}: Balance: #{player.money}. "
  end
  
  # Print hands of all the players
  def print_all_hands(players)
    players.each { |player|
        self.print_hand(player)
      }
  end
  
  # Get the action commands from the input. The parameters describe if double-down and splitting are valid.
  def get_command(can_double_down, can_split)
    self.print_msg('hit_or_stay')
    
    if can_double_down
      self.print_msg('can_double_down')
    end
    
    if can_split
      self.print_msg('can_split')
    end
    
    valid_input = false
    
    until valid_input do
      input = gets.chomp
      if input == "h" || input =="s" || (input == "d" && can_double_down) || (input == "x" && can_split)
        valid_input = true
      else
        self.print_msg('invalid_command')
      end
    end
    return input
  end
  
  # Print when player busts
  def print_busted_msg(player)
    puts "Player #{player.id}: Bust!"
  end
  
  # Horizontal separator
  def print_separator
    puts "------------------------------------------------------"
  end
  
  # Horizontal separator, strong
  def print_separator_strong
    puts "======================================================"
  end
  
  # Print at end of game
  def print_end
    print_separator_strong
    puts "GAME OVER!"
    print_separator_strong
  end
  
  # Print when a player becomes bankrupt
  def print_player_bankrupt(player)
    print_separator
    puts "Player #{player.id}: Bankrupt"
    print_separator
  end
  
  # Print a message comparing hands of the player and the dealer
  def print_vs_msg(player, dealer)
    print "Player #{player.id}: "
    
    if player.is_blackjack
      print "Blackjack! "
    elsif player.is_busted
      print "Bust! "
    else
      print "#{player.get_points} "
    end
    
    print "vs "
    print "Dealer: "
    
    if dealer.is_blackjack
      print "Blackjack! "
    elsif dealer.is_busted
      print "Bust! "
    else
      print "#{dealer.get_points} "
    end
    puts ""
  end
  
  # Print a message comparing the second hand of the player and the dealer
  def print_split_vs_msg(player, dealer)
    self.print_split_separator_2
    print "Player #{player.id}: "
    if player.is_split_blackjack
      print "Blackjack! "
    elsif player.is_split_busted
      print "Bust! "
    else
      print "#{player.get_split_points} "
    end
    print "vs "
    print "Dealer: "
    if dealer.is_blackjack
      print "Blackjack! "
    elsif dealer.is_busted
      print "Bust! "
    else
      print "#{dealer.get_points} "
    end
    puts ""
  end
  
  # Print when player has a blackjack
  def print_blackjack_msg(player)
    puts "Player: #{player.id}. Blackjack!"
  end
  
  # For player's first hand when a split is called
  def print_split_separator_1
    puts "--------------------"
    puts "Player's first hand"
    puts "--------------------"
  end
  
  # For player's second hand when a split is called
  def print_split_separator_2
    puts "--------------------"
    puts "Player's second hand"
    puts "--------------------"
  end
  
  # Print when dealing cards
  def print_deal_cards
    puts "-----------"
    puts "Cards Dealt"
    puts "-----------"
  end
  
  # Print the hand of the player
  def print_hand(player)
    player_hand = player.get_hand
    cards = player_hand.get_hand_cards
    print "Player: #{player.id}. Hand: "
    cards.each { |card|
      print "#{card.symbol}#{card.suit} "
    }
    puts "Points: #{player.get_points}. Bet: #{player.get_current_bet} "
  end
  
  # Print the second had of the player
  def print_split_hand(player)
    player_hand = player.get_split_hand
    cards = player_hand.get_hand_cards
    print "Player: #{player.id}. Hand: "
    cards.each { |card|
      print "#{card.symbol}#{card.suit} "
    }
    puts "Points: #{player.get_split_points}. Bet: #{player.get_split_bet} "
  end
  
  # Print the dealer's hand
  def print_dealers_hand(dealer)
    dealer_hand = dealer.get_hand
    cards = dealer_hand.get_hand_cards
    print "Dealer. Hand: "
    cards.each { |card|
      print "#{card.symbol}#{card.suit} "
    }
    puts "Points: #{dealer.get_points}."
  end
end