require "./kqueens"

class MinConflicts

  # Constructor of the class. Initializes the class variables.
  # +csp+:: Constraint satisfaction problem. This is the hole class defining the 
  # problem we need to solve.  
  # +max_steps+:: Max steps that the main loop of the algorithm can handle 
  # before returns a possible solution. 
  def initialize(csp, max_steps)
    @csp = csp  
    @max_steps = max_steps
  end

  # Solves the KQueens problem using min-conflicts algorithm with random walk.
  # We choose a random queen until the number of max steps is reached. For every 
  # random queen we find all the violations for the row then we find the indexes 
  # with lesser values and add them to the best_index array. If there are 
  # multiple values to choise the algorithm choose one randomly.
  # The random walk adds some randomnes allowing to the algorithm to doesn't get 
  # stuck in local minimums. It uses a provability that we can choose. The 
  # optimal value of this provability is 0.02 for faster problem solving but 
  # this value depends on the number of the queens.
  def solve_random_walk

    counter = 0
    while counter < @max_steps

      # Choosing the queen to evaluate.
      position = @csp.choose_queen
      row = position[0]
      column = position[1]

      # Generating the violation array for the row and finding the best value.
      violation_array = []
      best = 10 * @csp.m
      @csp.board[row].each_with_index do |n, index|
        violation = @csp.check_violations([row, index])
        best = violation if violation < best
        violation_array << violation
      end

      p = rand(0.0..1.0)
      if p <= 0.02
        @csp.board[row][column] = 0
        @csp.board[row][rand(@csp.board[row].length - 1)] = 1
      else

        # Finding the indexes of the best cases.
        best_index = []
        violation_array.each_with_index do |n, index|
          best_index << index if n == best
        end

        # Choosing one of the indexes randomly
        final_index = best_index[rand(best_index.length - 1)]

        # Moving the queen to the new best position
        @csp.board[row][column] = 0
        @csp.board[row][final_index] = 1

      end

      counter += 1

    end

  end

  # Solves the KQueens problem using min-conflicts algorithm with random walk.
  # We choose a random queen until the number of max steps is reached. For every 
  # random queen we find all the violations for the row then we find the indexes 
  # with lesser values and add them to the best_index array. If there are 
  # multiple values to choise the algorithm choose one randomly.
  def solve

    counter = 0
    while counter < @max_steps

      # Choosing the queen to evaluate.
      position = @csp.choose_queen
      row = position[0]
      column = position[1]

      # Generating the violation array for the row.
      violation_array = []
      @csp.board[row].each_with_index do |n, index|
        violation_array << @csp.check_violations([row, index])
      end

      # Finding the case with lesser violations.
      best = 10 * @csp.m
      violation_array.each do |n|
        best = n if n <= best
      end

      # Finding the indexes of the best cases.
      best_index = []
      violation_array.each_with_index do |n, index|
        best_index << index if n == best
      end

      # Choosing one of the indexes randomly
      final_index = best_index[rand(best_index.length - 1)]

      # Moving the queen to the new best position
      @csp.board[row][column] = 0
      @csp.board[row][final_index] = 1

      counter += 1

    end

  end

end
