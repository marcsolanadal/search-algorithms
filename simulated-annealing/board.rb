
class Board

  # Constructor of the class Board.
  # +m+:: Heigth of the board.
  # +n+:: Widht of the board.
  # +start+:: Position of the start of the puzzle.
  # +final+:: Position of the ideal final of the puzzle.
  # +w+:: Step wire value.
  # +d+:: Round wire value.
  def initialize(m, n, start, final, w, d)
    @m = m
    @n = n
    @start = start
    @final = final
    @w = w
    @d = d
    @num_moves = m * n - 1
  end

  def solve
   
    # Set initial temp and cooling_rate
    temp = 10000
    cooling_rate = 0.02

    # Initialize first solution
    start_solution = []
    valid = false 
    while ! valid
      start_solution = generate_random_solution
      valid = validate_solution(start_solution)
    end

    # Set as current best
    best_solution = start_solution

    # Loop until the system was cooled
    while temp > 1
      
      # Create a valid neighbour
      valid = false
      while ! valid
        neighbour = generate_neighbour(best_solution)
        valid = validate_solution(neighbour)
      end

      # Get the energy of the solutions
      current_energy = objective_function(best_solution)
      neighbour_energy = objective_function(neighbour)

      # Decide if we should accept the neighbour
      current_solution = neighbour if(acceptance_function(current_energy, neighbour_energy, temp) > rand())
        
      # Keep track of the best solution found
      best_solution = current_solution if(neighbour_energy < current_energy)

      # Cool the system
      temp *= 1 - cooling_rate      

    end

    puts "SOLUTION: #{best_solution}"

  end

  # Return a value based on the.
  # +energy+:: Energy of the first solution.
  # +energy2+:: Energy of the second solution.
  # +temperature+:: Actual temperature of the system.
  def acceptance_function(energy, energy2, temperature)
    return Math.exp(energy - energy2 / temperature) 
  end


  def generate_random_solution
    attempt = []
    @num_moves.times do |n|
      attempt[n] = rand(4)
    end
    return attempt
  end

  # We check if the solution is innbound. We start with the index zero and we do 
  # all the movements if move function returns a nil then the move_count will be 
  # different than the movement lenght at the end and we will know that some 
  # movement is not correct.
  # +solution+:: Vector with integers between 0..3 indicates the problem 
  # solution at the moment.
  # +return+:: true if the solution is innbound or false if not.
  def validate_solution(solution)
    position = @start.dup
    move_count = 0
    solution.each do |movement|
      next_position = move(movement, position)
      unless next_position.nil?
        position = next_position
        move_count += 1 
      end
    end
    move_count == @num_moves ? true : false
  end

  # Returns the position on the board of the applyed movement.
  # +movement+:: Integer between 0..3 that indicates the movement
  # * 0 -> North
  # * 1 -> South
  # * 2 -> East
  # * 3 -> West
  # +returns+:: Position with the movement applyed. 
  def move(mov, pos)
    case mov
    when 0
      Position.new(pos.x, pos.y - 1) if pos.y > 0
    when 1
      Position.new(pos.x, pos.y + 1) if pos.y < @m - 1
    when 2
      Position.new(pos.x + 1, pos.y) if pos.x < @n - 1
    when 3
      Position.new(pos.x - 1, pos.y) if pos.x > 0
    end
  end

  # Generate a neighbour of the parameter solution. It works generating a random 
  # number between 0..solution.length this number choose the index to change. Another 
  # random number between 0..3 changing the movement.
  # +solution+:: Vector with integers between 0..3 indicates the problem 
  # solution at the moment.
  # +returns+:: Solution randomly changed.
  def generate_neighbour(solution)
    new_solution = solution.dup
    while solution == new_solution
      new_solution[rand(solution.length)] = rand(4)
    end
    return new_solution
  end

  # This function calculates the performance of the solution that we pass as a 
  # parameter.
  # We generate a matrix of M x N dimensions with an offset in all positions 
  # except for start and final positions. This is for giving them more weight on 
  # the performance calculations.
  # Then we loop across all the movements of the solution knowing our position 
  # in the performance matrix. We increase the values of the matrix with the 
  # following rules:
  # Straight line = D
  # Curve = D + W
  # Repeated position = 50 * (D + W)
  # This rules determine the beheviour of the algorithm. We can change the 
  # values to change the behaviour.
  def objective_function(solution)
    offset = 5
    actual_position = @start.dup

    performance = Array.new(@m) { Array.new(@n) { offset } }
    performance[@start.x][@start.y] = 0
    performance[@final.x][@final.y] = 0

    solution.each_with_index do |movement, index|
      position = move(movement, actual_position)
      performance[position.y][position.x] += @d if solution[index] == solution[index + 1]
      performance[position.y][position.x] += (@d + @w) if solution[index] != solution[index + 1]
      performance[position.y][position.x] += 10 * (@d + @w) if performance[position.x][position.y] > (offset + @d + @w) 
      actual_position = position
    end

    total_performance = 0
    performance.each do |y|
      y.each do |x|
        total_performance += x
      end
    end

    return total_performance
  end
 
  # Return an array formated for correct visualization of the movements.
  # +array+:: Array of undefined lenght.
  # +return+:: Well formated string. 
  def get_formated(array)
    array_string = "["                                                                                                                          
    array.each do |cell|                                                                                                                                
      array_string << " #{cell}"                                                                                                                         
    end                                                                                                                                                  
    array_string << " ]"                                                                                                                                 
    return array_string                                                                                                                                  
  end        

end
