require_relative "../piece"

class Bishop < Piece
  def display_sym
    @color == "white" ? "♗" : "♝"
  end

  def possible(curr)
    moves = [
      # up and left
      [curr[0] - 1, curr[1] + 1],
      [curr[0] - 2, curr[1] + 2],
      [curr[0] - 3, curr[1] + 3],
      [curr[0] - 4, curr[1] + 4],
      [curr[0] - 5, curr[1] + 5],
      [curr[0] - 6, curr[1] + 6],
      [curr[0] - 7, curr[1] + 7],
      # up and right
      [curr[0] + 1, curr[1] + 1],
      [curr[0] + 2, curr[1] + 2],
      [curr[0] + 3, curr[1] + 3],
      [curr[0] + 4, curr[1] + 4],
      [curr[0] + 5, curr[1] + 5],
      [curr[0] + 6, curr[1] + 6],
      [curr[0] + 7, curr[1] + 7],
      # down and left
      [curr[0] - 1, curr[1] - 1],
      [curr[0] - 2, curr[1] - 2],
      [curr[0] - 3, curr[1] - 3],
      [curr[0] - 4, curr[1] - 4],
      [curr[0] - 5, curr[1] - 5],
      [curr[0] - 6, curr[1] - 6],
      [curr[0] - 7, curr[1] - 7],
      # down and right
      [curr[0] + 1, curr[1] - 1],
      [curr[0] + 2, curr[1] - 2],
      [curr[0] + 3, curr[1] - 3],
      [curr[0] + 4, curr[1] - 4],
      [curr[0] + 5, curr[1] - 5],
      [curr[0] + 6, curr[1] - 6],
      [curr[0] + 7, curr[1] - 7],
    ]

    moves.select { |x, y| x.between?(0, 7) && y.between?(0, 7) }
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
