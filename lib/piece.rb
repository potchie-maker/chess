class Piece
  attr_reader :color
  attr_accessor :pos, :moved_yet, :moves

  def initialize(color, pos)
    @color = color
    @pos = pos
    @moved_yet = false
    @moves = 0
  end

  def deep_piece_copy
    piece_copy = dup
    piece_copy.pos = @pos.dup
    piece_copy.moved_yet = @moved_yet
    piece_copy.moves = @moves
    piece_copy
  end
end
