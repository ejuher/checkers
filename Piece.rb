class Piece
	attr_accessor :pos, :board, :king
	attr_reader :color, :dr

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
		if king
			@dr = [1, -1]
		else
			@dr = color == :red ? [1] : [-1]
		end
	end

	def moves 
		moves = []
		deltas.each do |dr|
			[1, -1].each do |dc|
				move = [pos[0] + dr, pos[1] + dc]
				# puts "pos = #{ pos }"
				# puts "dr = #{ dr }"
				# puts "move = #{ move }" 
				#move is in bounds and not occuppied
				if in_bounds?(move) && board.grid[move[0]][move[1]].nil?
					moves << move 
				end
			end
		end
		moves
	end

	def perform_slide(end_pos)
		#if the move is legal
		if !in_bounds?(end_pos)
			raise "You cannot move out of bounds"
		elsif !(moves.include?(end_pos))
			raise "That move is out range for that piece"
		elsif !(board.grid[end_pos[0]][end_pos[1]].nil?)
			raise "Cannot move to an occuppied space"
		else
			force_move(end_pos)
		end
	end

	def perform_jump(end_pos)
	end

	def force_move(end_pos)
		board.grid[pos[0]][pos[1]] = nil
		pos = end_pos
		board.grid[end_pos[0]][end_pos[1]] = self
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
		grid[start[0]][start[1]].perform_slide(end_pos)
	end

end

b = Board.new
puts b
puts "value at [2, 0] #{ b.grid[2][0] }"
puts "moves for [2,0] #{ b.grid[2][0].moves }"
b.move([2, 0], [3, 1])
puts b