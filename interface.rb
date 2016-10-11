module Interface

  def draw(match)
    spacing_horizontal = "\t\t\t"
    spacing_vertical = "\n\n"
    letters_row = "  a b c d e f g h"

    puts "\e[H\e[2J"
    print match.player.to_s.capitalize, " player's turn. "
    if match.look_for_check
      print "Your King is in check."
    end
    print spacing_vertical

    print spacing_horizontal, letters_row, "\n", spacing_horizontal
    7.downto(0){ |y|
      print y+1, " "
      0.upto(7){ |x|
        print match.board[x][y], " "
      }
      print y+1, "\n", spacing_horizontal
    }
    print letters_row, spacing_vertical
  end

  def get_player_input
    print "Input your movement:"
    input = gets.chomp
    return decode_input(input)
  end


  def input_to_coordinates(input)
    return Coordinates.new(input[0], input[1]), Coordinates.new(input[2], input[3])
  end


  def decode_input(input)
    input = input.downcase.delete(' ').delete("\t").delete("\n")

    if input.length != 4
      return nil
    end

    input = input.codepoints

    input[0] -= 97
    input[1] -= 49
    input[2] -= 97
    input[3] -= 49

    input.each_index {|i| return nil if  (input[i] < 0 || input[i] > 7) }

    return input
  end

  def announce(message)
    puts message
  end

end


class Coordinates
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

end