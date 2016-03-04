require './checkers_puzzle'
require './search_node'

class AStar
    attr_accessor :open, :closed, :goal, :solution

  def initialize(start, goal)    
    @open = []
    @open << start
    @closed = []
    @goal = goal
    @solution = []
    @success = false
    agenda_loop
  end
  
  def agenda_loop
    while ! @success
        parent = @open.shift
        puts parent.get_formated_state
        if parent.state == @goal.state
            @success = true
            @solution << "SOLUTION FOUND!" 
            puts @solution
        else
            unless @closed.include? parent
                child_state = []
                parent.possible_actions.each do |action|
                    child_state << parent.result(action) 
                end
                # We create the child states sorted into open list
                child_state.each do |state|
                    @open <<  SearchNode.new(state, parent) 
                end
                @open.sort! { |a, b| a.f <=> b.f }
                @closed << parent
            end
        end
    end
  end
  
end
