require_relative "../piece"

class Queen < Piece
  def display_sym
    @color == :white ? "♕" : "♛"
  end

  def possible(curr, board)
    deltas = [
      # horizontal
      [0, -1], # left
      [0, 1], # right
      # vertical
      [-1, 0], # up
      [1, 0], # down
      # diagonals
      [-1, -1], # up-left
      [-1, 1], # up-right
      [1, 1], # down-right
      [1, -1], # down-left
    ]

    moves = []
    enemy_color = @color == :white ? :black : :white

    deltas.each do |row_delta, col_delta|
      1.upto(7) do |step|
        row = curr[0] + row_delta * step
        col = curr[1] + col_delta * step
        break unless row.between?(0, 7) && col.between?(0, 7)
        break if board[row][col]&.color == @color
        moves << [row, col]
        break if board[row][col]&.color == enemy_color
      end
    end
    moves
  end

  def moves(start, fin)
    queue = [[start, [start]]]
    visited = Set.new

    until queue.empty?
      curr, path = queue.shift
      if curr == fin
        yield(path) if block_given?
        return path
      end

      queen_possible(curr).each do |move|
        unless visited.include?(move)
          visited.add(move)
          queue << [move, path + [move]]
        end
      end
    end
  end
end
