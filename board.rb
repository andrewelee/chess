require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'pawn'
require_relative 'queen'
require_relative 'king'
require 'colorize'

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

  NOTATION = {
    1 => 7,
    2 => 6,
    3 => 5,
    4 => 4,
    5 => 3,
    6 => 2,
    7 => 1,
    8 => 0
  }

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    @captures = []
    @selected = nil

    8.times do |i|
      self[[0, i]] = TYPES[i].new([0, i], :black, self)
      self[[1, i]] = Pawn.new([1, i], :black, self)
      self[[7, i]] = TYPES[i].new([7, i], :white, self)
      self[[6, i]] = Pawn.new([6, i], :white, self)
    end
  end

  def in_check?(color)
    king_pos = @grid.flatten.find { |piece|
      piece.is_a?(King) && piece.color == color }.position

    @grid.flatten.compact.each do |piece|
      if piece.color != color
        return true if piece.moves.include?(king_pos)
      end
    end

    false
  end

  def checkmate?(color)
    king_pos = @grid.flatten.find { |piece|
      piece.is_a?(King) && piece.color == color }.position

    @grid.flatten.compact.each do |piece|
      if piece.color == color
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
    raise "Invalid movement" if !self[start].moves.include?(end_pos)
    @captures << self[end_pos] if self[end_pos]
    self[end_pos] = self[start]
    self[end_pos].position = end_pos
    self[start] = nil
    self
  end

  def coordinates(pos)
    coordinates = pos.reverse
    coordinates[0] = (coordinates[0] + 97).chr.upcase
    coordinates[1] = NOTATION[coordinates[1]]
    coordinates = coordinates.join
  end

  def display(selected = nil)
    i = 9
    puts "+ A B C D E F G H ".light_white.on_black
    @grid.each do |row|
      print "#{i -= 1}".light_white.on_black + " "
      row.each do |piece|
        if piece
          if (selected && selected == piece.position)
            print piece.symbol.colorize(:red) + ' '
          else
            print piece.symbol + ' '
          end
        else
          print '_ '
        end
      end
      puts
    end
    @captures.each { |piece| print piece.symbol }
    puts
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