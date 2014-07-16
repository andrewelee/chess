class HumanPlayer

  NOTATION = {
    "A" => 0,
    "B" => 1,
    "C" => 2,
    "D" => 3,
    "E" => 4,
    "F" => 5,
    "G" => 6,
    "H" => 7,
    "1" => 7,
    "2" => 6,
    "3" => 5,
    "4" => 4,
    "5" => 3,
    "6" => 2,
    "7" => 1,
    "8" => 0
  }

  def get_piece_pos(color)
    puts "#{color.capitalize}'s turn. Select a piece:"
    position = gets.chomp.upcase.split("").map {|x| NOTATION[x]}
  end

  def get_move(color)
    puts "Select a position to move to:"
    position = gets.chomp.upcase.split("").map {|x| NOTATION[x]}
  end
end