require_relative "pieces/bishop"
require_relative "pieces/king"
require_relative "pieces/knight"
require_relative "pieces/pawn"
require_relative "pieces/queen"
require_relative "pieces/rook"

class Board
  attr_accessor :board

  def initialize
    @board = Array.new(8) { Array.new(8) }
  end

  def piece_at(pos)
    row, col = pos
    @board[row][col]
  end

  def deep_board_copy
    board_copy = self.class.new
    board_copy.board = @board.map do |row|
      row.map do |piece|
        piece ? piece.deep_piece_copy : nil
      end
    end
    board_copy
  end

  def print_board
    puts "\n\n"
    row_notation = 8
    col_notation = ("a".."h").to_a
    transform_board.each do |row|
      puts row_notation.to_s + "  " + row.join("  ")
      row_notation -= 1
    end
    puts "   #{col_notation.join('  ')}"
  end

  def transform_board
    blank_board = Array.new(8) { |i| Array.new(8) { |j| (i + j).even? ? "□" : "■"} }
    @board.each_with_index.map do |row, i|
      row.each_with_index.map do |piece, j|
        piece ? piece.display_sym : blank_board[i][j]
      end
    end
  end

  def set_up
    # white pawns
    @board[6][0] = Pawn.new(:white, [6, 0])
    @board[6][1] = Pawn.new(:white, [6, 1])
    @board[6][2] = Pawn.new(:white, [6, 2] )
    @board[6][3] = Pawn.new(:white, [6, 3])
    @board[6][4] = Pawn.new(:white, [6, 4])
    @board[6][5] = Pawn.new(:white, [6, 5])
    @board[6][6] = Pawn.new(:white, [6, 6])
    @board[6][7] = Pawn.new(:white, [6, 7])
    # black pawns
    @board[1][0] = Pawn.new(:black, [1, 0])
    @board[1][1] = Pawn.new(:black, [1, 1])
    @board[1][2] = Pawn.new(:black, [1, 2])
    @board[1][3] = Pawn.new(:black, [1, 3])
    @board[1][4] = Pawn.new(:black, [1, 4])
    @board[1][5] = Pawn.new(:black, [1, 5])
    @board[1][6] = Pawn.new(:black, [1, 6])
    @board[1][7] = Pawn.new(:black, [1, 7])
    # rooks
    @board[7][0] = Rook.new(:white, [7, 0])
    @board[7][7] = Rook.new(:white, [7, 7])
    @board[0][0] = Rook.new(:black, [0, 0])
    @board[0][7] = Rook.new(:black, [0, 7])
    # knights
    @board[7][1] = Knight.new(:white, [7, 1])
    @board[7][6] = Knight.new(:white, [7, 6])
    @board[0][1] = Knight.new(:black, [0, 1])
    @board[0][6] = Knight.new(:black, [0, 6])
    # bishops
    @board[7][2] = Bishop.new(:white, [7, 2])
    @board[7][5] = Bishop.new(:white, [7, 5])
    @board[0][2] = Bishop.new(:black, [0, 2])
    @board[0][5] = Bishop.new(:black, [0, 5])
    # queens
    @board[7][3] = Queen.new(:white, [7, 3])
    @board[0][3] = Queen.new(:black, [0, 3])
    # kings
    @board[7][4] = King.new(:white, [7, 4])
    @board[0][4] = King.new(:black, [0, 4])
  end
end
