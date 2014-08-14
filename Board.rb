require './Piece'

class Board
	attr_accessor :grid

	def initialize(setup = true)
		@grid = Array.new(8) { Array.new (8) } 
		setup_board if setup
	end

	def to_s
		grid.map do |row|
			row.map do |col|
				col.nil? ? " " : col
			end.join(' ') + "\n"
		end.reverse.join 
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

end

b = Board.new
puts b
puts ""
b.move([2, 0], [3, 1])
puts b
puts "b.grid[3][1].pos = #{ b.grid[3][1].pos }"
puts ""
b.move([5, 3], [4, 2])
puts b
puts ""
puts "b.grid[3][1].pos = #{ b.grid[3][1].pos }"
b.grid[3][1].perform_jump([5,3])
puts b
puts ""
b.move([5, 1], [4, 0])
b.move([6, 2], [5, 1])
b.move([7, 1], [6, 2])
b.grid[5][3].perform_jump([7, 1])
puts b
puts ""

# puts "value at [2, 0] #{ b.grid[2][0] }"
# puts "moves for [2,0] #{ b.grid[2][0].moves }"