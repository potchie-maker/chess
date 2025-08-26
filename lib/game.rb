require_relative "board"
require_relative "position"

class Game
  include Position

  def initialize
    @game_board = Board.new
    @turn = :white
    @taken = { :white => [], :black => [] }
  end

  def play_game
    @game_board.set_up
    loop do
      @game_board.print_board
      player_turn
      if checkmate?
        @game_board.print_board
        return puts "Checkmate! #{@turn.to_s.capitalize} wins!" if checkmate?
      end
      if stalemate?
        @game_board.print_board
        return puts "Stalemate. This game ended in a draw." if stalemate?
      end
      @turn = enemy_color
    end
  end

  def player_turn
    puts "\n\n#{@turn.to_s.capitalize}, make your move."
    loop do
      start, fin = get_move
      if legal_move?(start, fin, skip_possible: false)
        move_piece(@game_board.board, start, fin)
        return
      end
    end
  end

  def get_move
    loop do
      puts "\n\nInput desired move."
      puts "Ex: e2 > e4\n\n"
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
    in_check?(@game_board.board) && !any_legal_moves?
  end

  def stalemate?
    !in_check?(@game_board.board) && !any_legal_moves?
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
    try_again_msg = "#{@turn.to_s.capitalize}, try again."
    piece = @game_board.piece_at(start)
    if piece.nil? || piece.color != @turn
      @game_board.print_board
      puts "\n\nA valid piece does not exist at that starting spot." unless skip_possible
      puts try_again_msg
      return false
    end

    if @game_board.piece_at(fin).is_a?(King)
      @game_board.print_board
      puts "\n\nCannot land on a King." unless skip_possible
      puts try_again_msg
      return false
    end

    unless skip_possible
      moves = piece.possible(piece.pos, @game_board.board)
      unless moves.include?(fin)
        @game_board.print_board
        puts "\n\nThat movement isn't possible."
        puts try_again_msg
        return false
      end
    end

    game_copy = @game_board.deep_board_copy
    move_piece(game_copy.board, start, fin)
    if in_check?(game_copy.board)
      @game_board.print_board
      puts "\n\nThat move leaves your King in check."
      puts try_again_msg
      return false
    end

    true
  end

  def in_check?(board)
    board.each_with_index do |row, i|
      row.each_with_index do |space, j|
        next unless space&.color == enemy_color
        moves = space.possible([i, j], board)
        return true if moves.include?(find_king(board))
      end
    end
    false
  end

  def find_king(board)
    board.each_with_index do |row, i|
      row.each_with_index do |space, j|
        return [i, j] if space.is_a?(King) && space.color == @turn
      end
    end
  end

  def move_piece(board, start, fin)
    board[fin[0]][fin[1]] = board[start[0]][start[1]]
    board[start[0]][start[1]] = nil
    piece = board[fin[0]][fin[1]]

    # auto queen pawn promotion
    if piece.is_a?(Pawn) && (fin[0] == 0 || fin[0] == 7)
      board[fin[0]][fin[1]] = Queen.new(piece.color, fin)
      piece = board[fin[0]][fin[1]]
    end

    piece.pos = fin
    piece.moved_yet = true
    piece.times_moved += 1
  end

  def enemy_color
    @turn == :white ? :black : :white
  end
end
