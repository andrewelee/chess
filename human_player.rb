class HumanPlayer
  def get_piece_pos(color)
    puts "#{color}'s turn. Select a piece:"
    YAML.load(gets.chomp)

  end

  def get_move(color)
    puts "Select a position to move to:"
    YAML.load(gets.chomp)
  end
end