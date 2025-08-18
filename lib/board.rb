require_relative "pieces/bishop"
require_relative "pieces/king"
require_relative "pieces/knight"
require_relative "pieces/pawn"
require_relative "pieces/queen"
require_relative "pieces/rook"

class Board
  def initialize
    @board = Array.new(8) { Array.new(8) }
  end

  def set_up
    # white pawns
    @board[6][0] = Pawn.new("white")
    @board[6][1] = Pawn.new("white")
    @board[6][2] = Pawn.new("white")
    @board[6][3] = Pawn.new("white")
    @board[6][4] = Pawn.new("white")
    @board[6][5] = Pawn.new("white")
    @board[6][6] = Pawn.new("white")
    @board[6][7] = Pawn.new("white")
    # black pawns
    @board[1][0] = Pawn.new("black")
    @board[1][1] = Pawn.new("black")
    @board[1][2] = Pawn.new("black")
    @board[1][3] = Pawn.new("black")
    @board[1][4] = Pawn.new("black")
    @board[1][5] = Pawn.new("black")
    @board[1][6] = Pawn.new("black")
    @board[1][7] = Pawn.new("black")
    # rooks
    @board[7][0] = Rook.new("white")
    @board[7][7] = Rook.new("white")
    @board[0][0] = Rook.new("black")
    @board[0][7] = Rook.new("black")
    # knights
    @board[7][1] = Knight.new("white")
    @board[7][6] = Knight.new("white")
    @board[0][1] = Knight.new("black")
    @board[0][6] = Knight.new("black")
    # bishops
    @board[7][2] = Bishop.new("white")
    @board[7][5] = Bishop.new("white")
    @board[0][2] = Bishop.new("black")
    @board[0][5] = Bishop.new("black")
    # queens
    @board[7][3] = Queen.new("white")
    @board[0][3] = Queen.new("black")
    # kings
    @board[7][4] = King.new("white")
    @board[0][4] = King.new("black")
  end
end
