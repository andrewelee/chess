require_relative 'stepping_piece'

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