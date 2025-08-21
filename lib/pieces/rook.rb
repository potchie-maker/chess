require_relative "../piece"

class Rook < Piece
  def display_sym
    @color == "white" ? "♖" : "♜"
  end

  def possible(curr, board)
    deltas = [
      [0, -1], # left
      [0, 1], # right
      [-1, 0], # up
      [1, 0], # down
    ]

    moves = []
    enemy_color = @color == "white" ? "black" : "white"

    deltas.each do |row_delta, column_delta|
      1.upto(7) do |step|
        row = curr[0] + row_delta * step
        col = curr[1] + column_delta * step
        break unless row.between?(0, 7) && column.between?(0, 7)
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

      rook_possible(curr).each do |move|
        unless visited.include?(move)
          visited.add(move)
          queue << [move, path + [move]]
        end
      end
    end
  end
end
