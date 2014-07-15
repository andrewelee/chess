require_relative 'piece'

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
