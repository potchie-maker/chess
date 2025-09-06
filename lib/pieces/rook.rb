require_relative "../piece"

class Rook < Piece
  def display_sym
    @color == :white ? "♖" : "♜"
  end

  def possible(curr, board_obj)
    board = board_obj.board

    deltas = [
      [0, -1], # left
      [0, 1], # right
      [-1, 0], # up
      [1, 0], # down
    ]

    sliding_moves(deltas, curr, board, max_slide: 7)
  end
end
