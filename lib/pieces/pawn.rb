require_relative "../piece"

class Pawn < Piece
  def display_sym
    @color == :white ? "♙" : "♟"
  end

  def attack_squares(curr, board_obj)
    r, c = curr
    dir = (color == :white ? -1 : 1)
    [[r + dir, c - 1], [r + dir, c + 1]].select { |nr, nc| nr.between?(0, 7) && nc.between?(0, 7) }
  end

  def possible(curr, board_obj)
    board = board_obj.board
    row, col = curr
    moves = []
    direction = @color == :white ? -1 : 1
    enemy_color = @color == :white ? :black : :white

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

    if (ep = board_obj.en_passant_target)
      tr, tc = ep
      if color == :white
        if row == tr + 1 && (col - tc).abs == 1
          moves << [tr, tc]
        end
      else
        if row == tr - 1 && (col - tc).abs == 1
          moves << [tr, tc]
        end
      end
    end

    moves
  end
end
