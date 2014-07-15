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