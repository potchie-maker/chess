require_relative "../piece"

class King < Piece
  def display_sym
    @color == :white ? "♔" : "♚"
  end

  def possible(curr, board_obj)
    board = board_obj.board
    r, _c = curr[0]
    moves = []

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

    moves = sliding_moves(deltas, curr, board, max_slide: 1)

    return moves if moved_yet

    if board[r][5].nil? && board[r][6].nil?
      rook = board[r][7]
      moves << [r, 6] if rook.is_a?(Rook) && !rook.moved_yet && rook.color == color
    end

    if board[r][1].nil? && board[r][2].nil? && board[r][3].nil?
      rook = board[r][0]
      moves << [r, 2] if rook.is_a?(Rook) && !rook.moved_yet && rook.color == color
    end

    moves
  end
end
