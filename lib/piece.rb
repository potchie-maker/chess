require_relative "./position"

class Piece
  include Position
  attr_reader :color, :pos, :moves

  def initialize(color)
    @color = color
    @pos = [0, 0] 
    @moved_yet = false
    @moves
  end
end
