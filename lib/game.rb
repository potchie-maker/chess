require_relative "board"

class Game
  def initialize
    @game_board = Board.new
  end

  def legal_move?(start, fin)
    start_conv = convert_notation_to_row_col(start) 
    fin_conv = convert_notation_to_row_col(fin)

    piece = @game_board.board[start_conv[0]][start_conv[1]]
    # target = game_board[fin_conv[0]][fin_conv[1]]

    moves = piece.possible(piece.pos, @game_board.board)
    return false unless moves.include?(fin_conv)
    true
  end
end
