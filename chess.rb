require 'yaml'

class Piece
  attr_accessor :position, :color, :board
  def initialize(position, color, board)
    @position = position
    @color = color
    @board = board
  end

  def moves
  end

  def symbol
  end

  def valid_moves
    moves.select { |pos| !self.move_into_check?(pos) }
  end

  def move_into_check?(pos)
    @board.dup.move(@position, pos).in_check?(@color)
  end

end

class SlidingPiece < Piece
  def move_dirs
  end

  def moves
    arr = []
    move_dirs.each do |delta|
      tmp = [self.position[0] + delta[0], self.position[1] + delta[1]]
      until tmp.any? { |n| n < 0 || n > 7 } || @board[tmp]
        arr << tmp.dup
        tmp[0] += delta[0]
        tmp[1] += delta[1]
      end
      arr << tmp.dup if @board[tmp] && @board[tmp].color != @color
    end
    arr
  end
end

class SteppingPiece < Piece
  def move_dirs
  end

  def moves
    arr = []
    move_dirs.each do |delta|
      tmp = [self.position[0] + delta[0], self.position[1] + delta[1]]
      unless tmp.any? { |n| n < 0 || n > 7 } ||
        (@board[tmp] && @board[tmp].color == self.color)
        arr << tmp.dup
      end
    end
    arr
  end
end

class Pawn < Piece
  attr_accessor :has_moved
  def initialize(position, color, board)
    @has_moved = false
    @direction = color == :black ? 1 : -1
    super(position, color, board)
  end

  def moves
    arr = []
    tmp = [2 * @direction + self.position[0], self.position[1]]
    arr << tmp.dup if !@has_moved && !@board[tmp]
    tmp = [@direction + self.position[0], self.position[1]]
    arr << tmp.dup if !@board[tmp]
    tmp[1] += 1
    arr << tmp.dup if @board[tmp] && @board[tmp].color != self.color
    tmp[1] -= 2
    arr << tmp if @board[tmp] && @board[tmp].color != self.color
    arr
  end

  def symbol
    color == :black ? "♟" : "♙"
  end
end

class Bishop < SlidingPiece
  DELTAS = [
    [ 1, 1],
    [ 1,-1],
    [-1,-1],
    [-1, 1]
  ]
  def move_dirs
    DELTAS
  end
  def symbol
    @color == :black ? "♝" : "♗"
  end
end

class Rook < SlidingPiece
  DELTAS = [
    [ 1, 0],
    [-1, 0],
    [ 0,-1],
    [ 0, 1]
  ]
  def move_dirs
    DELTAS
  end
  def symbol
    @color == :black ? "♜" : "♖"
  end
end

class Queen < SlidingPiece
  DELTAS = [
    [ 1, 1],
    [ 1,-1],
    [-1,-1],
    [-1, 1],
    [ 1, 0],
    [-1, 0],
    [ 0,-1],
    [ 0, 1]
  ]
  def move_dirs
    DELTAS
  end
  def symbol
    @color == :black ? "♛" : "♕"
  end
end

class Knight < SteppingPiece
  DELTAS = [
    [ 2, 1],
    [ 2,-1],
    [-2, 1],
    [-2,-1],
    [ 1, 2],
    [ 1,-2],
    [-1, 2],
    [-1,-2]
  ]

  def move_dirs
    DELTAS
  end
  def symbol
    @color == :black ? "♞" : "♘"
  end
end

class King < SteppingPiece
  DELTAS = [
    [ 1, 1],
    [ 1,-1],
    [-1,-1],
    [-1, 1],
    [ 1, 0],
    [-1, 0],
    [ 0,-1],
    [ 0, 1]
  ]

  def move_dirs
    DELTAS
  end

  def symbol
    @color == :black ? '♚' : "♔"
  end
end

class Board
  TYPES = [
    Rook,
    Knight,
    Bishop,
    Queen,
    King,
    Bishop,
    Knight,
    Rook
  ]

  def initialize
    @grid = Array.new(8) { Array.new(8) }

    i = 0
    while i < 8
      self[[0, i]] = TYPES[i].new([0, i], :black, self)
      self[[1, i]] = Pawn.new([1, i], :black, self)
      self[[7, i]] = TYPES[i].new([7, i], :white, self)
      self[[6, i]] = Pawn.new([6, i], :white, self)
      i += 1
    end
  end
  def in_check?(color)
    king_pos = @grid.flatten.select { |piece|
      piece.is_a?(King) && piece.color == color }[0].position
    @grid.flatten.each do |piece|
      if piece && piece.color != color
        return true if piece.moves.include?(king_pos)
      end
    end
    false
  end
  def checkmate?(color)
    king_pos = @grid.flatten.select { |piece|
      piece.is_a?(King) && piece.color == color }[0].position
    @grid.flatten.each do |piece|
      if piece && piece.color == color
        return false if !piece.valid_moves.empty?
      end
    end
    true
  end
  def [](pos)
    return nil if pos.any? { |n| n < 0 || n > 7 }
    @grid[pos[0]][pos[1]]
  end
  def []=(pos, val)
    @grid[pos[0]][pos[1]] = val if !pos.any? { |n| n < 0 || n > 7 }
  end
  def move(start, end_pos)
    raise "No piece found at #{start}" if self[start].nil?
    raise "Invalid movement" if !self[start].moves.include?(end_pos)
    old_val = self[end_pos]
    self[end_pos] = self[start]
    self[end_pos].position = end_pos
    self[start] = nil
    self
  end
  def display
    i = -1
    puts "+ 0 1 2 3 4 5 6 7"
    @grid.each do |row|
      print "#{i += 1} "
      row.each do |piece|
        print piece ? piece.symbol + ' ' : '_ '
      end
      puts
    end
  end
  def dup
    new_board = Board.new
    (0..8).each do |x|
      (0..8).each do |y|
        new_board[[x, y]] = self[[x, y]] ? self[[x, y]].dup : nil
        new_board[[x, y]].board = new_board if new_board[[x, y]]
      end
    end
    new_board
  end
end

class Game

  def initialize(player1, player2)
    @players = {:white => player1, :black => player2}
    @board = Board.new
  end

  def play
    turns = 1
    color = :white
    while !@board.checkmate?(color)
      @board.display
      begin
        piece_pos = @players[color].get_piece_pos(color).reverse
        raise "Cannot select opponent's piece" if
          @board[piece_pos] &&
          @board[piece_pos].color != color
        str = @board[piece_pos].class
        puts "#{str}"
        move = @players[color].get_move(color).reverse
        old_board = @board.dup
        @board.move(piece_pos, move)
        if @board.in_check?(color)
          @board = old_board
          raise "Move would result in a check"
        elsif @board[move].is_a?(Pawn)
          @board[move].has_moved = true
        end
      rescue StandardError => error
        puts error.message
        puts error.backtrace
        retry
      end
      puts "Check!" if @board.in_check?(color == :white ? :black : :white)
      color = color == :white ? :black : :white
      turns += 1
    end
    @board.display
    color = color == :white ? :black : :white
    puts "Checkmate! Winner: #{color} in #{turns/2} moves"

  end

end

class HumanPlayer
  def get_piece_pos(color)
    puts "#{color}'s turn. Select a piece:"
    YAML.load(gets.chomp)

  end

  def get_move(color)
    puts "Select a position to move to:"
    YAML.load(gets.chomp)
  end
end

g = Game.new(HumanPlayer.new, HumanPlayer.new)
g.play
