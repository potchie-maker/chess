module Position
  # "notation" refers to chess notation like "e4"
  #
  # "xy" refers to the way the piece move methods navigate the graph
  # they use regular (x, y) plotting
  # [0, 0] is the bottom left corner of the board
  #
  # "row_col" refers to the ruby array notation of the 8x8 board
  # [0, 0] will be used as board[0][0] and would be the top left corner of the board
  def convert_notation_to_row_col(notation)
    row = 8 - notation[1].to_i
    column = notation[0].ord - "a".ord
    [row, column]
  end

  def convert_xy_to_row_col(move)
    row = 7 - move[1]
    column = move[0]
    [row, column]
  end

  def convert_row_col_to_xy(coord)
    x = coord[1]
    y = 7 - coord[0]
    [x, y]
  end
end
