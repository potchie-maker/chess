require_relative "board"

class Game
  def initialize
    @game_board = Board.new
    @turn = white
    @opp = black
  end

  def legal_move?(start, fin)
    start_conv = convert_notation_to_row_col(start) 
    fin_conv = convert_notation_to_row_col(fin)

    piece = @game_board.piece_at(start_conv)
    return false if piece.nil?

    moves = piece.possible(piece.pos, @game_board.board)
    return false unless moves.include?(fin_conv)
  end

  def move_piece
  end

  def find_kings
    kings = []
    @game_board.each_with_index do |row, i|
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
        next unless space&.color == @opp
        moves = space.possible([i, j], board)
        check_pieces << [i, j] if find_kings.any? { |king_pos| moves.include?(king_pos) }
      end
    end
    !check_pieces.empty?
  end
end
