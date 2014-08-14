require './Board.rb'

class Game
	attr_reader :board, :turn

	def initialize
		@board = Board.new
		@turn = :red
	end

	def run
		until board.over?
			puts board
			input = get_input
			process_input(input)
			swap_turns
		end
	end

	def correct_turn?(color)
		color == turn
	end

	def get_input
		valid_piece = false
		until valid_piece == true
			puts "It's #{turn}'s turn"
			puts "Enter coordinates of piece you want to move (y,x):"

			piece = gets.chomp.split(',').map { |unit| Integer(unit) }
			if correct_turn?(board.grid[piece[0]][piece[1]].color)
				valid_piece = true
			else
				puts "You cannot move pieces which are not yours"
			end
		end

		puts "Enter coordinates of where to move piece."
		puts "Seperate coordinate pairs with spaces if you wish to make multiple jumps"

		moves = gets.chomp.split
		moves.map! { |coord| coord.split(',') }

		moves.map! { |coord| [Integer(coord[0]), Integer(coord[1])] }

		moves.unshift(piece)
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