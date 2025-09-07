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
      @turn = enemy_color
      if checkmate?
        @game_board.print_board
        return puts "Checkmate! #{enemy_color.to_s.capitalize} wins!"
      end
      if stalemate?
        @game_board.print_board
        return puts "Stalemate. This game ended in a draw."
      end
    end
  end

  def player_turn
    puts "\n\n#{@turn.to_s.capitalize}, make your move."
    loop do
      start, fin = get_move
      if legal_move?(start, fin, skip_possible: false)
        move_piece(@game_board, start, fin)
        return
      end
    end
  end

  def get_move
    loop do
      puts "\n\nInput desired move."
      puts "Ex: e2 > e4 (or) e2>e4\n\n"
      input = gets.chomp
      if  (m = /\A\s*(?<start>[a-h][1-8])\s*>\s*(?<fin>[a-h][1-8])\s*\z/i.match(input))
        start = convert_notation_to_row_col(m[:start].downcase)
        fin = convert_notation_to_row_col(m[:fin].downcase)
        return [start, fin]
      end
      @game_board.print_board
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
        piece.possible([i, j], @game_board).each do |fin|
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
      moves = piece.possible(piece.pos, @game_board)
      unless moves.include?(fin)
        @game_board.print_board
        puts "\n\nThat movement isn't possible."
        puts try_again_msg
        return false
      end
    end

    if piece.is_a?(King) && (fin[1] - start[1]).abs == 2
      if in_check?(@game_board)
        @game_board.print_board
        puts "\n\nCannot castle while in check."
        puts try_again_msg
        return false
      end

      step = fin[1] > start[1] ? 1 : -1
      through = [start[0], start[1] + step]
      if square_attacked_by?(@game_board, through, enemy_color)
        @game_board.print_board
        puts "\n\nCannot castle through check."
        puts try_again_msg
        return false
      end
    end

    if piece.is_a?(Pawn) && (fin[0] == 0 || fin[0] == 7)
      [:queen, :rook, :bishop, :knight].each do |promo|
        game_copy = @game_board.deep_board_copy
        move_piece(game_copy, start, fin, simulate: true, promotion: promo)
        return true unless in_check?(game_copy)
      end
      @game_board.print_board
      puts "\n\nThat promotion would leave King in check (all choices)."
      puts try_again_msg
      return false
    else
      game_copy = @game_board.deep_board_copy
      move_piece(game_copy, start, fin, simulate: true)
      if in_check?(game_copy)
        @game_board.print_board
        puts "\n\nThat move leaves your King in check."
        puts try_again_msg
        return false
      end
    end

    true
  end

  def in_check?(board_obj)
    king_pos = find_king(board_obj)
    square_attacked_by?(board_obj, king_pos, enemy_color)
  end

  def find_king(board_obj)
    board = board_obj.board
    board.each_with_index do |row, i|
      row.each_with_index do |space, j|
        return [i, j] if space.is_a?(King) && space.color == @turn
      end
    end
    nil
  end

  def square_attacked_by?(board_obj, square, by_color)
    board = board_obj.board
    tr, tc = square
    board.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        next unless piece&.color == by_color
        attacks = 
          if piece.respond_to?(:attack_squares)
            piece.attack_squares([i, j], board_obj)
          else
            piece.possible([i, j], board_obj)
          end
        return true if attacks.include?([tr, tc])
      end
    end
    false
  end

  def move_piece(board_obj, start, fin, simulate: false, promotion: nil)
    board = board_obj.board
    sr, sc = start
    fr, fc = fin
    piece = board[sr][sc]

    board_obj.en_passant_target = nil

    # en passant capture removal
    if piece.is_a?(Pawn) && board[fr][fc].nil? && sc != fc
      cap_row = piece.color == :white ? fr + 1 : fr - 1
      board[cap_row][fc] = nil
    end

    # piece movement
    board[fr][fc] = piece
    board[sr][sc] = nil

    # promotion
    if piece.is_a?(Pawn) && (fr == 0 || fr == 7)
      new_pos = [fr, fc]
      new_piece = 
        if simulate
          case promotion
          when :queen then Queen.new(piece.color, new_pos)
          when :rook then Rook.new(piece.color, new_pos)
          when :bishop then Bishop.new(piece.color, new_pos)
          when :knight then Knight.new(piece.color, new_pos)
          else
            Queen.new(piece.color, new_pos)
          end
        else
          promote_to_choice(piece.color, new_pos)
        end
      board[fr][fc] = new_piece
      piece = new_piece
    end

    # set en passant target
    if piece.is_a?(Pawn) && (sr - fr).abs == 2
      mid_row = (sr + fr) / 2
      board_obj.en_passant_target = [mid_row, fc]
    end

    piece.pos = [fr, fc]
    piece.moved_yet = true
    piece.times_moved += 1

    # rook castle movement
    if piece.is_a?(King) && (fc - sc).abs == 2
      r = fr
      if fc == 6 # king-side
        rook_from = [r, 7]
        rook_to = [r, 5]
      else       # queen-side
        rook_from = [r, 0]
        rook_to = [r, 3]
      end
      rook = board[rook_from[0]][rook_from[1]]
      board[rook_to[0]][rook_to[1]] = rook
      board[rook_from[0]][rook_from[1]] = nil
      rook.pos = rook_to
      rook.moved_yet = true
      rook.times_moved += 1
    end
  end

  def promote_to_choice(color, pos)
    loop do
      puts "\n\nPromote to (Q, R, B, N)?"
      choice = gets&.chomp&.strip&.downcase
      case choice
      when "q", "queen" then return Queen.new(color, pos)
      when "r", "rook" then return Rook.new(color, pos)
      when "b", "bishop" then return Bishop.new(color, pos)
      when "n", "k", "knight" then return Knight.new(color, pos)
      else
        puts "\n\nInvalid choice. Type Q, R, B, or N."
      end
    end
  end

  def enemy_color
    @turn == :white ? :black : :white
  end
end
