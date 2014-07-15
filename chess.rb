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
end

class SlidingPiece < Piece
  def move_dirs
  end

  def moves
    arr = []
    move_dirs.each do |delta|
      tmp = [self.position[0] + delta[0], self.position[1] + delta[1]]
      until tmp.any? { |n| n < 0 || n > 7 } ||
        (@board[tmp] && @board[tmp].color == self.color)
        arr << tmp
        tmp[0] += delta[0]
        tmp[1] += delta[1]
      end
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
        arr << tmp
      end
    end

    arr
  end
end

class Pawn < Piece
  def initialize(position, color, board)
    @has_moved = false
    @direction = color == :black ? 1 : -1
    super(position, color, board)
  end

  def moves
    arr = []
    tmp = [self.position[0], 2 * direction + self.position[1]]
    arr << tmp if !@has_moved && !@board[tmp]
    tmp = [self.position[0], direction + self.position[1]]
    arr << tmp if !@board[tmp]
    tmp[0] += 1
    arr << tmp if @board[tmp] && @board[tmp].color != self.color
    tmp[0] -= 2
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
  end
  def [](pos)
    return nil if pos.any? { |n| n < 0 || n > 7 }
    @grid[pos[0]][pos[1]]
  end
  def []=(pos, val)
    @grid[pos[0]][pos[1]] = val
  end
  def move(start, end_pos)
    raise "No piece found at #{start}" if self[start].nil?
    raise "Invalid movement" if !self[start].moves.include?(end_pos)
    self[end_pos] = self[start]
    self[end_pos].position = end_pos
    self[start] = nil
  end
  def display
    @grid.each do |row|
      row.each do |piece|
        print piece ? piece.symbol + ' ' : '_ '
      end
      puts
    end
  end
end

b = Board.new
b.display
