require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'pawn'
require_relative 'queen'
require_relative 'king'

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
    king_pos = @grid.flatten.find { |piece|
      piece.is_a?(King) && piece.color == color }.position

    @grid.flatten.each do |piece|
      if piece && piece.color == color
        return false if !piece.valid_moves.empty?
      end
    end
    true
  end

  def [](pos)
    @grid[pos[0]][pos[1]] if pos.all? { |n| n.between?(0, 7) }
  end

  def []=(pos, val)
    @grid[pos[0]][pos[1]] = val if pos.all? { |n| n.between?(0, 7) }
  end

  def move(start, end_pos)
    raise "No piece found at #{start}" if self[start].nil?
    raise "Invalid movement" if !self[start].moves.include?(end_pos)
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