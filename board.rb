require './pieces.rb'
require './interface.rb'
include Interface

class Match
  #stores and control the state of the match
  attr_reader :board, :pieces, :player

  def initialize
    set_up_pieces
    set_up_match
  end

  def set_up_pieces
    @pieces = Pieces.new
  end

  def clear_board
    Array.new(8){ Array.new(8){ EMPTY_SPACE } }
  end


  def set_up_match
    @board = clear_board

    #place white pieces
    @board[0][0] = WHITE_ROOK
    @board[1][0] = WHITE_KNIGHT
    @board[2][0] = WHITE_BISHOP
    @board[3][0] = WHITE_QUEEN
    @board[4][0] = WHITE_KING
    @board[5][0] = WHITE_BISHOP
    @board[6][0] = WHITE_KNIGHT
    @board[7][0] = WHITE_ROOK
    (0..7).each{ |i|
      @board[i][1] = WHITE_PAWN
    }

    #place black pieces
    @board[0][7] = BLACK_ROOK
    @board[1][7] = BLACK_KNIGHT
    @board[2][7] = BLACK_BISHOP
    @board[3][7] = BLACK_QUEEN
    @board[4][7] = BLACK_KING
    @board[5][7] = BLACK_BISHOP
    @board[6][7] = BLACK_KNIGHT
    @board[7][7] = BLACK_ROOK
    (0..7).each{ |i|
      @board[i][6] = BLACK_PAWN
    }

    #set up starting player
    @player = :white
  end


  def move(from, to)

    if validate_movement(from, to, @board) && validate_king_out_of_check(to, from)
      @board[to.x][to.y] = @board[from.x][from.y]
      @board[from.x][from.y] = EMPTY_SPACE
      @player = (@player == :white ? :black : :white)
      true
    else
      Interface.announce("Movement not allowed.")
      false
    end

  end


  def validate_movement(from, to, arrangement= @board)

    piece = @pieces[arrangement[from.x][from.y]]
    destination = @pieces[arrangement[to.x][to.y]]

    return false if piece.nil? || to == from || piece.color != @player
    return false unless piece.validate_destination(from, to, destination.color)

    piece.class != Knight ? validate_path(from, to, arrangement) : true

  end


  def validate_path(from, to, arrangement)

    direction_x = (to.x - from.x) != 0 ? (to.x - from.x)/(to.x - from.x).abs : 0
    direction_y = (to.y - from.y) != 0 ? (to.y - from.y)/(to.y - from.y).abs : 0
    path_x = from.x
    path_y = from.y
    distance = [(to.x - from.x).abs, (to.y - from.y).abs].max

    (1 ... distance).each{
      path_x += direction_x
      path_y += direction_y
      return false unless arrangement[path_x][path_y] == EMPTY_SPACE
    }

    true
  end


  def validate_king_out_of_check(to, from)
    tentative_arrangement = set_tentative_arrangement(to, from)

    look_for_check(tentative_arrangement) ? false : true
  end


  def set_tentative_arrangement(to, from)
    arrangement = Array.new(8){ Array.new(8){ :* } }
    (0..7).each{ |y|
      (0..7).each{ |x|
        arrangement[x][y] = @board[x][y]
      }
    }
    arrangement[to.x][to.y] = arrangement[from.x][from.y]
    arrangement[from.x][from.y] = EMPTY_SPACE

    arrangement
  end


  def look_for_check(arrangement= @board)
    king_position = get_king_coordinates(arrangement)
    piece_position = Coordinates.new(-1, -1)

    (0..7).each{ |y|
      (0..7).each{ |x|
        piece = @pieces[arrangement[x][y]]
        if arrangement[x][y] != EMPTY_SPACE && piece.color != @player
          piece_position.x = x
          piece_position.y = y
          if piece.validate_destination(piece_position, king_position, @player)
            if piece.class == Knight || validate_path(piece_position, king_position, arrangement)
              return true
            end
          end
        end
      }
    }
    false
  end


  def get_king_coordinates(arrangement)
    (0..7).each{ |y|
      (0..7).each{ |x|
        if @player == :white && arrangement[x][y] == WHITE_KING
          return Coordinates.new(x, y)
        elsif @player == :black && arrangement[x][y] == BLACK_KING
          return Coordinates.new(x, y)
        end
      }
    }
  end

  def checkmate?
    piece_position = Coordinates.new(-1, -1)
    tentative_position = Coordinates.new(-1, -1)

    (0..7).each{ |y|
      (0..7).each{ |x|
        piece = @pieces[@board[x][y]]
        if piece.color == @player
          piece_position.x, piece_position.y = x, y
          (0..7).each{ |i|
            (0..7).each{|j|
              tentative_position.x, tentative_position.y  = j, i
              tentative_destination = @pieces[@board[j][i]].color
              if piece.validate_destination(piece_position, tentative_position, tentative_destination)
                if piece.class == Knight || validate_path(piece_position, tentative_position, @board)
                  arrangement = set_tentative_arrangement(piece_position, tentative_position)
                  return false unless look_for_check(arrangement)
                end
              end
            }
          }
          end
      }
    }
    true
  end

end
