require_relative "../piece"

class Pawn < Piece
  def display_sym
    @color == "white" ? "♙" : "♟"
  end

  def possible(curr, board)
    row, col = curr
    moves = []

    direction = @color == "white" ? -1 : 1
    enemy_color = @color == "white" ? "black" : "white"

    forward_one = row + direction
    if forward_one.between?(0, 7) && board[forward_one][col].nil?
      moves << [forward_one, col]

      forward_two = row + 2 * direction
      if !moved_yet && forward_two.between?(0, 7) && board[forward_two][col].nil?
        moves << [forward_two, col]
      end
    end

    [-1, 1].each do |col_delt|
      atk_col = col + col_delt
      if forward_one.between?(0, 7) && atk_col.between?(0, 7)
        target = board[forward_one][atk_col]
        moves << [forward_one, atk_col] if target&.color == enemy_color
      end
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

      pawn_possible(curr).each do |move|
        unless visited.include?(move)
          visited.add(move)
          queue << [move, path + [move]]
        end
      end
    end
  end
end
