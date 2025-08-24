require_relative "board"
require_relative "position"

class Game
  include Position

  def initialize
    @game_board = Board.new
    @turn = "white"
    @taken = { "white" => [], "black" => [] }
  end

  def player_turn
    puts "\n\n#{@turn.capitalize}, make your move."
    loop do
      start, fin = get_move
      if legal_move?(start, fin)
        move_piece(@game_board.board, start, fin)
        @turn = enemy_color
        return
      end
      puts "\n\nMove is not legal. #{@turn.capitalize}, try again."
    end
  end

  def get_move
    loop do
      puts "\n\nInput desired move."
      puts "Ex: e2 > e4"
      input = gets.chomp
      if  (m = /\A\s*(?<start>[a-h][1-8])\s*>\s*(?<fin>[a-h][1-8])\s*\z/i.match(input))
        start = convert_notation_to_row_col(m[:start].downcase)
        fin = convert_notation_to_row_col(m[:fin].downcase)
        return [start, fin]
      end
      puts "\n\nInvalid move input. Try again"
    end
  end

  def legal_move?(start, fin)
    piece = @game_board.piece_at(start)
    return false if piece.nil?

    moves = piece.possible(piece.pos, @game_board.board)
    return false unless moves.include?(fin)

    game_copy = @game_board.deep_board_copy
    move_piece(game_copy.board, start, fin)
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
