require_relative "../piece"

class Pawn < Piece
  def display_sym
    @color == "white" ? "♙" : "♟"
  end

  def possible(curr, board)
    moves = [
      [curr[0] + 0, curr[1] + 1],
    ]
    unless @moved_yet
      moves << [curr[0] + 0, curr[1] + 2]
      @moved_yet = true
    end

    if board[]
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

      pawn_possible(curr).each do |move|
        unless visited.include?(move)
          visited.add(move)
          queue << [move, path + [move]]
        end
      end
    end
  end
end
