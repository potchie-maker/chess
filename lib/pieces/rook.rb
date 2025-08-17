class Rook
  def initialize(color)
    @color = color
    @pos = [0, 0] 
  end

  def rook_possible(curr)
    moves = [
      [curr[0] + 1, curr[1] + 2],
      [curr[0] + 2, curr[1] + 1],
      [curr[0] + 2, curr[1] - 1],
      [curr[0] + 1, curr[1] - 2],
      [curr[0] - 1, curr[1] - 2],
      [curr[0] - 2, curr[1] - 1],
      [curr[0] - 2, curr[1] + 1],
      [curr[0] - 1, curr[1] + 2]
    ]

    moves.select { |x, y| x.between?(0, 7) && y.between?(0, 7) }
  end

  def rook_moves(start, fin)
    queue = [[start, [start]]]
    visited = Set.new

    until queue.empty?
      curr, path = queue.shift
      if curr == fin
        yield(path) if block_given?
        return path
      end

      knight_possible(curr).each do |move|
        unless visited.include?(move)
          visited.add(move)
          queue << [move, path + [move]]
        end
      end
    end
  end
end
