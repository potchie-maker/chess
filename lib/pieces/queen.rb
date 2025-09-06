require_relative "../piece"

class Queen < Piece
  def display_sym
    @color == :white ? "♕" : "♛"
  end

  def possible(curr, board_obj)
    board = board_obj.board

    deltas = [
      # horizontal & vertical
      [0, -1], # left
      [0, 1], # right
      [-1, 0], # up
      [1, 0], # down
      # diagonals
      [-1, -1], # up-left
      [-1, 1], # up-right
      [1, 1], # down-right
      [1, -1], # down-left
    ]

    sliding_moves(deltas, curr, board, max_slide: 7)
  end
end
