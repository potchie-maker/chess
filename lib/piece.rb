class Piece
  attr_reader :color
  attr_accessor :pos, :moved_yet, :times_moved

  def initialize(color, pos)
    @color = color
    @pos = pos
    @moved_yet = false
    @times_moved = 0
  end

  def sliding_moves(deltas, curr, board, max_slide:)
    moves = []
    enemy_color = @color == :white ? :black : :white

    deltas.each do |row_delta, col_delta|
      1.upto(max_slide) do |step|
        row = curr[0] + row_delta * step
        col = curr[1] + col_delta * step
        break unless row.between?(0, 7) && col.between?(0, 7)
        break if board[row][col]&.color == @color
        moves << [row, col]
        break if board[row][col]&.color == enemy_color
      end
    end
    moves
  end

  def deep_piece_copy
    piece_copy = dup
    piece_copy.pos = @pos.dup
    piece_copy.moved_yet = @moved_yet
    piece_copy.times_moved = @times_moved
    piece_copy
  end
end
