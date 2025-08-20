require_relative "./position"

class Piece
  include Position
  attr_reader :color

  def initialize(color)
    @color = color
    @pos = [0, 0] 
    @moved_yet = false
  end
end
