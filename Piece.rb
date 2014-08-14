class Piece
	attr_reader :color

	def initialize(board, pos, color)
		@board = board
		@pos = pos
		@color = color
		@king = false
	end

	def in_bounds?(pos)
		pos[0].between?(0,7) && pos[1].between?(0,7)
	end

	def deltas
		dr = :color == :red ? 1 : -1
	end

	def perform_slide(end_pos)

	end

	def perform_jump(end_pos)
	end

	def promote?
	end

	def to_s
		color.to_s[0]
	end
end

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
					grid[row][col] = Piece.new(self, [row, col], color)
				end
			end
		end
	end

	def move(start, end_pos)
	end

end

b = Board.new
puts b