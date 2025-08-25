require_relative "board"
require_relative "position"

class Game
  include Position

  def initialize
    @game_board = Board.new
    @turn = :white
    @taken = { :white => [], :black => [] }
  end

  def player_turn
    puts "\n\n#{@turn.to_s.capitalize}, make your move."
    loop do
      start, fin = get_move
      if legal_move?(start, fin, skip_possible: false)
        move_piece(@game_board.board, start, fin)
        @turn = enemy_color
        return
      end
      puts "\n\nMove is not legal. #{@turn.to_s.capitalize}, try again."
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
      puts "\n\nInvalid move input. Try again."
    end
  end

  def checkmate?
    in_check?(@game_board) && !any_legal_moves?
  end

  def stalemate?
    !in_check?(@game_board) && !any_legal_moves?
  end

  def any_legal_moves?
    @game_board.board.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        next unless piece&.color == @turn
        piece.possible([i, j], @game_board.board).each do |fin|
          return true if legal_move?([i, j], fin, skip_possible: true)
        end
      end
    end
    false
  end

  def legal_move?(start, fin, skip_possible: false)
    piece = @game_board.piece_at(start)
    if piece.nil? || piece.color != @turn
      puts "A valid piece does not exist at that starting spot." unless skip_possible
      return false
    end

    if @game_board.piece_at(fin).is_a?(King)
      puts "Cannot land on a King." unless skip_possible
      return false
    end

    unless skip_possible
      moves = piece.possible(piece.pos, @game_board.board)
      unless moves.include?(fin)
        puts "That movement isn't possible."
        return false
      end
    end

    game_copy = @game_board.deep_board_copy
    move_piece(game_copy.board, start, fin)
    if in_check?(game_copy.board)
      puts "That move leaves your King in check."
      return false
    end

    true
  end

  def in_check?(board)
    board.each_with_index do |row, i|
      row.each_with_index do |space, j|
        next unless space&.color == enemy_color
        moves = space.possible([i, j], board)
        retur true if find_kings(board).any? { |king_pos| moves.include?(king_pos) }
      end
    end
    false
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

  def move_piece(board, start, fin)
    board[fin[0]][fin[1]] = board[start[0]][start[1]]
    board[start[0]][start[1]] = nil
    piece = board[fin[0]][fin[1]]
    piece.pos = fin
    piece.moved_yet = true
    piece.times_moved += 1
  end

  def enemy_color
    @turn == :white ? :black : :white
  end
end
