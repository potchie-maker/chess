require_relative "../piece"

class Bishop < Piece
  def display_sym
    @color == "white" ? "♗" : "♝"
  end

  def possible(curr, board)
    deltas = [
      [-1, -1], # up-left
      [-1, 1], # up-right
      [1, 1], # down-right
      [1, -1], # down-left
    ]

    moves = []
    enemy_color = @color == "white" ? "black" : "white"

    deltas.each do |row_delta, column_delta|
      1.upto(7) do |step|
        row = curr[0] + row_delta * step
        col = curr[1] + column_delta * step
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

      bishop_possible(curr).each do |move|
        unless visited.include?(move)
          visited.add(move)
          queue << [move, path + [move]]
        end
      end
    end
  end
end
