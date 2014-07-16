require 'yaml'
require_relative 'board'
require_relative 'human_player'

class Game

  def initialize(player1, player2)
    @players = {:white => player1, :black => player2}
    @board = Board.new
  end

  def play
    turns = 1
    color = :white
    while !@board.checkmate?(color)
      @board.display

      begin
        piece_pos = @players[color].get_piece_pos(color).reverse
        raise "No piece selected." if @board[piece_pos].nil?

        raise "Cannot select opponent's piece" if
          @board[piece_pos] &&
          @board[piece_pos].color != color

        puts "Selected: #{@board[piece_pos].class}"
        @board.display(piece_pos)
        move = @players[color].get_move(color).reverse
        old_board = @board.dup
        @board.move(piece_pos, move)

        if @board.in_check?(color)
          @board = old_board
          raise "Move would result in a check"
        elsif @board[move].is_a?(Pawn)
          @board[move].has_moved = true

          if @board[move].position[0] == 0 || @board[move].position[0] == 7
            color = @board[move].color
            promotion = @board[move].promote
            @board[move] = promotion.new(move, color, @board)
          end
        end

      rescue StandardError => error
        puts error.message
        #puts error.backtrace
        retry
      end

      puts "Check!" if @board.in_check?(color == :white ? :black : :white)
      color = color == :white ? :black : :white
      turns += 1
    end

    @board.display
    color = color == :white ? :black : :white
    puts "Checkmate! Winner: #{color} in #{turns/2} moves"
  end


end

g = Game.new(HumanPlayer.new, HumanPlayer.new)
g.play
