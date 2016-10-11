require './pieces_unicode'
require './interface.rb'
include Pieces_Unicode


class Pieces
#dictionary of pieces

  attr_reader :pieces

  def initialize
    set_up_pieces
  end

  def[](v)
    @pieces[v]
  end

  def set_up_pieces
    @pieces = { WHITE_KING => King.new(:white, WHITE_KING),
                WHITE_QUEEN => Queen.new(:white, WHITE_QUEEN),
                WHITE_ROOK => Rook.new(:white, WHITE_ROOK),
                WHITE_BISHOP => Bishop.new(:white, WHITE_BISHOP),
                WHITE_KNIGHT => Knight.new(:white, WHITE_KNIGHT),
                WHITE_PAWN => Pawn.new(:white, WHITE_PAWN),

                BLACK_KING => King.new(:black, BLACK_KING),
                BLACK_QUEEN => Queen.new(:black, BLACK_QUEEN),
                BLACK_ROOK => Rook.new(:black, BLACK_ROOK),
                BLACK_BISHOP => Bishop.new(:black, BLACK_BISHOP),
                BLACK_KNIGHT => Knight.new(:black, BLACK_KNIGHT),
                BLACK_PAWN => Pawn.new(:black, BLACK_PAWN),

                EMPTY_SPACE => Empty_Space.new
    }
  end
end


class Piece
#base class for every piece
#it's extensions will control each piece movement pattern

  @symbol_code = {}
  attr_reader :color, :symbol

  def initialize(color, symbol)
      @color = color
      @symbol = symbol
  end

end


class King < Piece
  def validate_destination(from, to, destination)
    return nil if @color == destination

    (to.x - from.x).abs <= 1 && (to.y - from.y).abs <= 1 ? true : false
  end
end


class Queen < Piece
  def validate_destination(from, to, destination)
    return nil if @color == destination

    t = (to.x == from.x) || (to.y == from.y) || (to.x - from.x).abs == (to.y - from.y).abs
    t ? true : false
  end
end


class Rook < Piece
  def validate_destination(from, to, destination)
    return nil if @color == destination
    (to.x == from.y) || (to.y == from.y) ? true : false
  end
end


class Bishop < Piece
  def validate_destination(from, to, destination)
    return nil if @color == destination

    (to.x - from.x).abs == (to.y - from.y).abs ? true : false
  end
end


class Knight < Piece
  def validate_destination(from, to, destination)
    return nil if @color == destination

    t = ((to.x - from.x).abs == 2 && (to.y - from.y).abs == 1) ||
        ((to.x - from.x).abs == 1 && (to.y - from.y).abs == 2)

    t ? true : false
  end
end


class Pawn < Piece
  def validate_destination(from, to, destination)
    unless destination.nil?
      return nil if @color == destination
      if @color == :white
        return ((to.x - from.x).abs == 1 && (to.y - from.y) == 1) ? true : false
      else
        return ((to.x - from.x).abs == 1 && (to.y - from.y) == -1) ? true : false
      end
    end

    if @color == :white
      return true if (from.y == 1 && to.y == 3 && from.x == to.x)
      to.x == from.x && to.y - from.y == 1 ? true : false
    else
      return true if (from.y == 6 && to.y == 4 && to.x == from.x)
      from.x == to.x && (to.y - from.y) == -1 ? true : false
    end
  end

end


class Empty_Space
#represents the empty spaces on the board
  attr_reader :symbol, :color

  def initialize
    @symbol = EMPTY_SPACE
    @color = nil
  end

end