class Pawn
  def initialize(name)
    @name = name
    @pos = [0, 0] 
    @moved_yet = false
  end

  def pawn_possible(curr)
    moves = [
      [curr[0] + 0, curr[1] + 1],
    ]
    unless @moved_yet
      moves << [curr[0] + 0, curr[1] + 2]
      @moved_yet = true
    end

    moves.select { |x, y| x.between?(0, 7) && y.between?(0, 7) }
  end

  def pawn_moves(start, fin)
    queue = [[start, [start]]]
    visited = Set.new

    until queue.empty?
      curr, path = queue.shift
      if curr == fin
        yield(path) if block_given?
        return path
      end

      pawn_possible(curr).each do |move|
        unless visited.include?(move)
          visited.add(move)
          queue << [move, path + [move]]
        end
      end
    end
  end
end
