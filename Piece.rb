# require './Board'

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

	def slide_moves 
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
		elsif !(slide_moves.include?(end_pos))
			raise "That move is out range for that piece"
		elsif !(board.grid[end_pos[0]][end_pos[1]].nil?)
			raise "Cannot move to an occuppied space"
		else
			force_move(end_pos)
		end
	end

	def jump_moves
		moves = []
		deltas.each do |dr|
			[1, -1].each do |dc|
				move = [pos[0] + dr * 2, pos[1] + dc * 2]

				if in_bounds?(move) && board.grid[move[0]][move[1]].nil?
					
					enemy_bool = !(board.grid[pos[0] + dr][pos[1] + dc].nil?) && (board.grid[pos[0] + dr][pos[1] + dc].color != color)

					moves << move if enemy_bool
				end
			end
		end
		moves
	end

	def perform_jump(end_pos)
		if !in_bounds?(end_pos)
			raise "You cannot move out of bounds"
		end

		jumped_pos = [((pos[0] + end_pos[0]) / 2), ((pos[1] + end_pos[1]) / 2)]
		jumped_piece = board.grid[jumped_pos[0]][jumped_pos[1]] 

		if !(board.grid[end_pos[0]][end_pos[1]].nil?)
			raise "Cannot jump to an occuppied space"
		elsif jumped_piece.nil?
			raise "Cannot jump an empty space"
		elsif jumped_piece.color == color
			raise "Cannot jump your own piece"
		elsif !(jump_moves.include?(end_pos))
			raise "That move is out range for that piece"
		else
			board.grid[jumped_pos[0]][jumped_pos[1]] = nil
			force_move(end_pos)
		end
	end

	def force_move(end_pos)
		board.grid[pos[0]][pos[1]] = nil
		@pos = end_pos
		board.grid[end_pos[0]][end_pos[1]] = self
		promote
		# puts "board.grid[pos[0]][pos[1]] = #{ board.grid[pos[0]][pos[1]].pos }"
		# puts "should be #{ end_pos }"
	end

	def promote
		back_row = color == :red ? 7 : 0

		if pos[0] == back_row && king == false
			puts "king me!"
			@king = true
		end
	end

	def to_s
		king ? color[0].to_s.upcase : color[0].to_s
	end
end

#BUG: tried setting instance variables with attr_accessor methods within same class
#CAN'T DO THAT!
#Have to set their values with direct calls to @variable
