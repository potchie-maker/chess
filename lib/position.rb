module Position
  # "notation" refers to chess notation like "e4"
  #
  # "row_col" refers to the ruby array notation of the 8x8 board
  # [0, 0] will be used as board[0][0] and would be the top left corner of the board
  def convert_notation_to_row_col(notation)
    row = 8 - notation[1].to_i
    col = notation[0].ord - "a".ord
    [row, col]
  end
end
