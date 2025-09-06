require_relative "../piece"

class Knight < Piece
  def display_sym
    @color == :white ? "♘" : "♞"
  end

  def possible(curr, board_obj)
    board = board_obj.board

    deltas = [
      # left-up
      [-1, -2], [-2, -1],
      # right-up
      [-2, 1], [-1, 2],
      # right-down
      [1, 2], [2, 1],
      # left-down
      [2, -1], [1, -2],
    ]

    enemy_color = @color == :white ? :black : :white

    moves = deltas.map{ |row_delta, col_delta| [curr[0] + row_delta, curr[1] + col_delta]}
    moves.select do |row, col|
      row.between?(0, 7) &&
      col.between?(0, 7) &&
      (board[row][col]&.nil? || board[row][col]&.color == enemy_color)
    end
  end
end
