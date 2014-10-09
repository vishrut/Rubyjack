# Rubyjack

This is a simple Blackjack game made using Ruby.

You can run this game by

    ruby BlackjackGame.rb

Rules of the game:

*  Dealer hits on 16 and stands on hard and soft 17
*  Players start with $1000
*  Players can double-down, as well as split, after a split
*  Blackjack is paid out at 3:2
*  Normal win is paid out at 1:1
*  Blackjacks on split are also paid out at 3:2
*  Aces automatically assume the optimal values. eg: (A+3 = 14) *hit* (A+3+9 = 13)
*  You will only see the commands for doubling down and split if you have enough money
*  Dealer peeks for Blackjack.
*  Since the players are making integer bets, winnings will always be floored.

You can have a look at the Rdoc generated docs for more info.

Have fun!

![There was supposed to be an image here :/](https://github.com/vishrut/Rubyjack/blob/master/rj.png "I like the retro look")

