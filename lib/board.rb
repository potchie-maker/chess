require_relative "pieces/bishop"
require_relative "pieces/king"
require_relative "pieces/knight"
require_relative "pieces/pawn"
require_relative "pieces/queen"
require_relative "pieces/rook"

class Board
  attr_reader :board

  def initialize
    @board = Array.new(8) { Array.new(8) }
  end

  def print_board
    puts "\n\n"
    row_notation = 8
    coloumn_notation = ("a".."h").to_a
    transformed_board = transform_board
    transformed_board.each do |row|
      puts row_notation.to_s + "  " + row.join("  ")
      row_notation -= 1
    end
    puts "   " + coloumn_notation.join("  ")
  end

  def transform_board
    blank_board = [
      ["□", "■", "□", "■", "□", "■", "□", "■"],
      ["■", "□", "■", "□", "■", "□", "■", "□"],
      ["□", "■", "□", "■", "□", "■", "□", "■"],
      ["■", "□", "■", "□", "■", "□", "■", "□"],
      ["□", "■", "□", "■", "□", "■", "□", "■"],
      ["■", "□", "■", "□", "■", "□", "■", "□"],
      ["□", "■", "□", "■", "□", "■", "□", "■"],
      ["■", "□", "■", "□", "■", "□", "■", "□"],
    ]
    written_board = Array.new(@board[0].length) { Array.new(@board[0].length) }
    blank_board.each_with_index do |row, i|
      row.each_with_index do |space, j|
        unless @board[i][j].nil?
          written_board[i][j] = @board[i][j].display_sym
        else
          written_board[i][j] = blank_board[i][j]
        end
      end
    end
    written_board
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
