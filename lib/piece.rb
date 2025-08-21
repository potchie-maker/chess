require_relative "./position"

class Piece
  include Position
  attr_reader :color, :pos, :moves

  def initialize(color, pos)
    @color = color
    @pos = pos
    @moved_yet = false
    @moves
  end
end
