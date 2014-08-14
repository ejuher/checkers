require './InvalidMoveError'

class Piece
	attr_accessor :pos, :board, :king
	attr_reader :color, :dr

	def initialize(board, pos, color, king = false)
		@board = board
		@pos = pos
		@color = color
		@king = king
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
			raise InvalidMoveError.new "You cannot move out of bounds"
		elsif !(slide_moves.include?(end_pos))
			raise InvalidMoveError.new "That move is out range for that piece"
		elsif !(board.grid[end_pos[0]][end_pos[1]].nil?)
			raise InvalidMoveError.new "Cannot move to an occuppied space"
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
			raise InvalidMoveError.new "Cannot jump to occuppied space at #{end_pos}"
		elsif jumped_piece.nil?
			raise InvalidMoveError.new "Cannot jump to empty space at at #{end_pos} from #{pos}"
		elsif jumped_piece.color == color
			raise InvalidMoveError.new "Cannot jump your own piece at #{jumped_pos}"
		elsif !(jump_moves.include?(end_pos))
			raise InvalidMoveError.new "The move #{end_pos} is out range for the piece at #{pos}"
		else
			board.grid[jumped_pos[0]][jumped_pos[1]] = nil
			force_move(end_pos)
		end
	end

	def perform_moves!(move_seq)
		if move_seq.length == 1 
			if slide_moves.include?(move_seq[0])
				perform_slide(move_seq[0]) 
			else
				perform_jump(move_seq[0])
			end
		else
			move_seq.each do |move|
				begin
					perform_jump(move)
				rescue InvalidMoveError => e
					puts "Illegal Move: #{e.message}" 
				end
			end
		end
	end

	def valid_move_seq?(move_seq)
		board_copy = board.dup
		begin
			board_copy.grid[pos[0]][pos[1]].perform_moves!(move_seq)
		rescue InvalidMoveError => e
			puts "Illegal Move: #{e.message}"
		  false
		else
			true
		end
	end

	def perform_moves(move_seq)
		perform_moves!(move_seq) if valid_move_seq?(move_seq)
	end

	def force_move(end_pos)
		board.grid[pos[0]][pos[1]] = nil
		@pos = end_pos
		board.grid[end_pos[0]][end_pos[1]] = self
		maybe_promote
	end

	def maybe_promote
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
