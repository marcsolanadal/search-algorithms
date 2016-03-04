require './position'
require './board'

start = Position.new(0, 0)
final = Position.new(2, 2)

board = Board.new(3, 3, start, final, 1, 1)

board.solve
