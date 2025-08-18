class King
  def initialize(color)
    @color = color
    @pos = [0, 0] 
    @moved_yet = false
  end

  def king_possible(curr)
    moves = [
      # horizontal & vertical
      [curr[0] - 1, curr[1] + 0],
      [curr[0] + 1, curr[1] + 0],
      [curr[0] + 0, curr[1] + 1],
      [curr[0] + 0, curr[1] - 1],
      # diagonal
      [curr[0] - 1, curr[1] + 1],
      [curr[0] + 1, curr[1] + 1],
      [curr[0] - 1, curr[1] - 1],
      [curr[0] + 1, curr[1] - 1],
    ]

    moves.select { |x, y| x.between?(0, 7) && y.between?(0, 7) }
  end

  def king_moves(start, fin)
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
