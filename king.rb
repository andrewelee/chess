require_relative 'stepping_piece'

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