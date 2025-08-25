require_relative "../piece"

class Knight < Piece
  def display_sym
    @color == :white ? "♘" : "♞"
  end

  def possible(curr, board)
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

  def moves(start, fin)
    queue = [[start, [start]]]
    visited = Set.new

    until queue.empty?
      curr, path = queue.shift
      if curr == fin
        yield(path) if block_given?
        return path
      end

      possible(curr).each do |move|
        unless visited.include?(move)
          visited.add(move)
          queue << [move, path + [move]]
        end
      end
    end
  end
end
