require_relative 'piece'

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

  def promote
    promotions =
    {
      "rook" => Rook,
      "knight" => Knight,
      "bishop" => Bishop,
      "queen" => Queen
    }

    puts "Pawn has advanced and can now be promoted! Select a piece: "
    promotion = promotions[gets.chomp.downcase]

  end

  def symbol
    color == :black ? "♟" : "♙"
  end
end