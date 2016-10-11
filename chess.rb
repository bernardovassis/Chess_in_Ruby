require './board.rb'
require './interface.rb'
include Interface

module Chess
#operates the game cycle

  def run

    #initialize game and draw the board
    match = Match.new
    Interface.draw(match)

    #this is the game cycle
    while true

      #checks for checkmate,  interrupts game cycle and end the match if found
      if match.look_for_check && match.checkmate?
        Interface.announce("Checkmate. Game Over.")
        break
      end

      #get input from player, retry until a valid input is provided
      while true
        input = Interface.get_player_input
        input ? break : Interface.announce("Invalid movement notation.")
      end
      from, to = Interface.input_to_coordinates(input)

      #process the move
      match.move(from, to)

      #draw the board
      Interface.draw(match)

    end
  end

  def initialize_game

  end
end
