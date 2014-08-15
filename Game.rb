require './board.rb'

class Game
	attr_reader :board, :turn

	def initialize
		@board = Board.new
		@turn = :red
	end

	def run
		until board.over?
			puts board
			begin
				input = get_input
				process_input(input)
			rescue InvalidMoveError => e
				puts 'HERE'
				puts "Illegal Move: #{e.message}"
				retry
			end
			swap_turns
		end
	end

	def correct_turn?(color)
		color == turn
	end

	def get_input
		start_piece = get_start_piece
		moves = get_moves
		moves.unshift(start_piece)
	end

	def get_start_piece
		puts "It's #{turn}'s turn"
		puts "Enter coordinates of piece you want to move (y,x):"

		piece = gets.chomp.split(',').map { |unit| Integer(unit) }

		if !(Piece.in_bounds?(piece))
			raise InvalidMoveError.new "Those coordinates are not in bounds"
		elsif board.empty_square?(piece)
			raise InvalidMoveError.new "There is no piece at those coordinates"
		elsif !(correct_turn?(board.grid[piece[0]][piece[1]].color))
			raise InvalidMoveError.new "You cannot move pieces which are not yours"			
		end
		piece
	end

	def get_moves
		puts "Enter coordinates of where to move piece."
		puts "Seperate coordinate pairs with spaces if you wish to make multiple jumps"

		moves = gets.chomp.split
		moves.map! { |coord| coord.split(',') }

		moves.map! { |coord| [Integer(coord[0]), Integer(coord[1])] }
	end

	def process_input(input)
		piece = input.shift
		board.grid[piece[0]][piece[1]].perform_moves(input)
	end

	def swap_turns
		@turn = turn == :red ? :black : :red
	end
end

game = Game.new
game.run