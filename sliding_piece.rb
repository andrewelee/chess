require_relative 'piece'

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
