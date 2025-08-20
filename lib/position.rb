module Position
  def convert_notation(notation)
    row = 8 - notation[1].to_i
    column = notation[0].ord - "a".ord
    [row, column]
  end

  def convert_move_to_index(move)
    row = 7 - move[1]
    column = move[0]
    [row, column]
  end
end
