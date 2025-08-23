require_relative "board"

class Game
  def initialize
    @game_board = Board.new
    @turn = "white"
    @taken = { "white" => [], "black" => [] }
  end

  def legal_move?(start, fin)
    start_conv = convert_notation_to_row_col(start) 
    fin_conv = convert_notation_to_row_col(fin)

    piece = @game_board.piece_at(start_conv)
    return false if piece.nil?

    moves = piece.possible(piece.pos, @game_board.board)
    return false unless moves.include?(fin_conv)

    game_copy = @game_board.deep_board_copy
    move_piece(game_copy.board, start_conv, fin_conv)
    return false if in_check?(game_copy.board)

    true
  end

  def move_piece(board, start, fin)
    board[fin[0]][fin[1]] = board[start[0]][start[1]]
    board[start[0]][start[1]] = nil
  end

  def find_kings(board)
    kings = []
    board.each_with_index do |row, i|
      row.each_with_index do |space, j|
        kings << [i, j] if space.is_a?(King)
      end
    end
    kings
  end

  def in_check?(board)
    check_pieces = []
    board.each_with_index do |row, i|
      row.each_with_index do |space, j|
        next unless space&.color == enemy_color
        moves = space.possible([i, j], board)
        check_pieces << [i, j] if find_kings(board).any? { |king_pos| moves.include?(king_pos) }
      end
    end
    !check_pieces.empty?
  end

  def enemy_color
    @turn == "white" ? "black" : "white"
  end
end
