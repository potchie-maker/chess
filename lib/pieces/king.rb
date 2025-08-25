require_relative "../piece"

class King < Piece
  def display_sym
    @color == :white ? "♔" : "♚"
  end

  def possible(curr, board)
    deltas = [
      # horizontal & vertical
      [0, -1], # left
      [0, 1], # right
      [-1, 0], # up
      [1, 0], # down
      # diagonals
      [-1, -1], # up-left
      [-1, 1], # up-right
      [1, 1], # down-right
      [1, -1], # down-left
    ]

    sliding_moves(deltas, curr, board, max_slide: 1)
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
