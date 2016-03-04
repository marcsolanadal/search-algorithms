require './search_node'
require './astar'

class CheckersPuzzle
  attr_accessor :actual_state, :previous_state
  
  def initialize(pieces)
    @actual_state = generate_puzzle(pieces)
    @previous_state = @actual_state
  end
  
  def solve
    goal = SearchNode.new(@actual_state.reverse)
    start = SearchNode.new(@actual_state)
    AStar.new(start, goal)
  end

  def generate_puzzle(pieces)
    cells = pieces + 1
    state = Array.new(cells)
    state.each_with_index do |cell, index|
      state[index] = (index < pieces/2) ? 'B' : 'R'
    end
    state[pieces/2] = "F"
    state
  end

end
