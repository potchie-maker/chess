require_relative "../piece"

class King < Piece
  def display_sym
    @color == :white ? "♔" : "♚"
  end

  def possible(curr, board)
    deltas = [
      # horizontal & vertical
      [-1, 0],
      [1, 0],
      [0, 1],
      [0, -1],
      # diagonal
      [-1, 1],
      [1, 1],
      [-1, -1],
      [1, -1],
    ]

    moves = []

    deltas.each do |row_delta, col_delta|
      row = curr[0] + row_delta
      col = curr[1] + col_delta
      next unless row.between?(0, 7) && col.between?(0, 7)
      next if board[row][col]&.color == @color
      moves << [row, col]
    end
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

      king_possible(curr).each do |move|
        unless visited.include?(move)
          visited.add(move)
          queue << [move, path + [move]]
        end
      end
    end
  end
end
