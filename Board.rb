require './Piece'

class Board
	attr_accessor :grid

	def initialize(setup = true)
		@grid = Array.new(8) { Array.new (8) } 
		setup_board if setup
	end

	def to_s
		num = -1
		display = grid.map do |row|
			num += 1
			row.map do |col|
				col.nil? ? " " : col
			end.unshift(num).join(' ') + "\n"
		end.reverse 
		display += ["  0 1 2 3 4 5 6 7\n"]
		display.join
	end

	def setup_board
		setup(:red)
		setup(:black)
	end

	def setup(color)
		start_row = color == :red ? 0 : 5

		(start_row..start_row + 2).each do |row|
			(0..7).each do |col|
				if (col.even? && row.even?) || (col.odd? && row.odd?)
					@grid[row][col] = Piece.new(self, [row, col], color)
				end
			end
		end
	end

	def move(start, end_pos)
		@grid[start[0]][start[1]].perform_slide(end_pos)
	end

	def dup
		board_copy = self.class.new(false)
		get_pieces.each do |piece|
			piece_copy = Piece.new(board_copy, piece.pos, piece.color, piece.king)
			board_copy.grid[piece_copy.pos[0]][piece_copy.pos[1]] = piece_copy
		end
		board_copy
	end

	def get_pieces
		grid.flatten.compact
	end

	def over?
		colors = get_pieces.map { |piece| piece.color }
		if !colors.include?(:red)
			puts "Black wins!"
			return true
		elsif !colors.include?(:black)
			puts "Red wins!"
			return true
		end
		false
	end

end

# b = Board.new

# puts b
# puts ""
# b.move([2, 0], [3, 1])
# puts b
# puts ""
# b.move([5, 3], [4, 2])
# puts b
# puts ""
# b.grid[3][1].perform_jump([5,3])
# puts b
# puts ""
# b.move([5, 1], [4, 0])
# b.move([6, 2], [5, 1])
# b.move([7, 1], [6, 2])
# b.grid[5][3].perform_jump([7, 1])
# puts b
# puts ""
# b.move([7,3], [6,2])
# b.move([5,5], [4,4])
# puts b
# puts ""
# b.grid[7][1].perform_moves([[5,3],[3,5]])
# puts b



# puts "value at [2, 0] #{ b.grid[2][0] }"
# puts "moves for [2,0] #{ b.grid[2][0].moves }"