require_relative 'sliding_piece'

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