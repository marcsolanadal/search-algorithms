
class SearchNode
  attr_accessor :state, :g, :f, :free_index

  def initialize(state, parent = self)
    @state = state
    @g = parent == self ? 1 : parent.g + 1
    @h = calculate_h
    @f = @g + @h
    @valid_action = ["Move(Black)", "Move(Red)", "Jump(Black)", "Jump(Red)"]
    @free_index = index_of_free
    @parent = parent
  end

  def index_of_free
    free = 0
    @state.each_with_index do |cell, index|
      free = index if cell == 'F'
    end
    return free
  end
  
  def get_formated_state
    state_string = "["
    @state.each do |cell|
      state_string << " #{cell}" 
    end
    state_string << " ]"
    return state_string
  end

  def valid_action?(action)
    valid = false
    @valid_action.each do |a|
      if a == action
        valid = true
      end
    end
    return valid
  end  
  
  def move_red_adjacent
    free = @free_index
    temp_state = @state.dup
    if temp_state[free + 1] == 'R' || temp_state[free - 1] == 'R'
      if free - 1 >= 0
        index = free - 1 if temp_state[free - 1] == 'R' 
      else
        puts "ERROR: Red adjacent movement out of bound for the lower limit."
      end
      if free + 1 <= temp_state.length
        index = free + 1 if temp_state[free + 1] == 'R'
      else
        puts "ERROR: Red adjacent movement out of bound for the upper limit."
      end
      x = temp_state[index]
      temp_state[index] = 'F'
      temp_state[free] = x
    else
      puts "ERROR: Wrong movement move_red_adjacent."
    end
    return temp_state
  end
  
  def move_black_adjacent
    free = @free_index
    temp_state = @state.dup
    if temp_state[free + 1] == 'B' || temp_state[free - 1] == 'B'
      if free - 1 >= 0
        index = free - 1 if temp_state[free - 1] == 'B' 
      else
        puts "ERROR: Black adjacent movement out of bound for the lower limit."
      end
      if free + 1 <= temp_state.length
        index = free + 1 if temp_state[free + 1] == 'B'
      else
        puts "ERROR: Black adjacent movement out of bound for the upper limit."
      end
      x = temp_state[index]
      temp_state[index] = 'F'
      temp_state[free] = x
    else
      puts "ERROR: Wrong movement move_black_adjacent."
    end
    return temp_state
  end
  
  def move_red_jump
    free = @free_index
    temp_state = @state.dup
    if temp_state[free + 2] == 'R' || temp_state[free - 2] == 'R'
      if free - 2 >= 0        
        index = free - 2 if temp_state[free - 2] == 'R' 
      else
        puts "ERROR: Red jump movement out of bounds for the lower limit."
      end
      if free + 2 <= temp_state.length
        index = free + 2 if temp_state[free + 2] == 'R'
      else
        puts "ERROR: Red jump movement out of bound for the upper limit."
      end
      x = temp_state[index]
      temp_state[index] = 'F'
      temp_state[free] = x
    else
      puts "ERROR: Wrong movement move_red_jump."
    end
    return temp_state
  end
  
  def move_black_jump
    free = @free_index
    temp_state = @state.dup
    if temp_state[free + 2] == 'B' || temp_state[free - 2] == 'B'
      if free - 2 >= 0
        index = free - 2 if temp_state[free - 2] == 'B' 
      else
        puts "ERROR: Black jump movement out of bounds for the lower limit."
      end
      if free + 2 <= temp_state.length
        index = free + 2 if temp_state[free + 2] == 'B'
      else
        puts "ERROR: Black jump movement out of bounds for the upper limit."
      end
      x = temp_state[index]
      temp_state[index] = 'F'
      temp_state[free] = x
    else
      puts "ERROR: Wrong movement move_black_jump."
    end
    return temp_state
  end
  
  def possible_move_index
    previous_free = @parent.free_index
    adjacent_index = []
    free = @free_index
    adjacent_index << free - 1 << free + 1
    
    # Discard the previous moved piece
    if adjacent_index.include? previous_free
      adjacent_index.delete(previous_free)
    end
    
    return adjacent_index
  end
  
  def possible_jump_index
    
    previous_free = @parent.free_index
    jump_index = []
    free = @free_index

    if @state[free - 1] == @state[free + 1]
      adjacent_colour = @state[free - 1]
      for index in free - 2 .. free + 2
        if @state[index] != 'F'
            if @state[index] != adjacent_colour
                if index + 2 <= @state.length && index - 2 >= 0
                    jump_index << index
                end
            end
        end
      end
    end
    
    # Discard the previous moved piece
    if jump_index.include? previous_free
      jump_index.delete(previous_free)
    end
    
    return jump_index
    
  end

  def result(action)

    adjacent_movement = possible_move_index
    jump_movement = possible_jump_index
    
    case action
    when "Move(Red)"
        new_state = move_red_adjacent if adjacent_movement.size != 0
    when "Move(Black)"
        new_state = move_black_adjacent if adjacent_movement.size != 0
    when "Jump(Red)"
        new_state = move_red_jump if jump_movement.size != 0
    when "Jump(Black)"    
        new_state = move_black_jump if jump_movement.size != 0
    end
    return new_state
  end
 
    def possible_actions

        # TODO: Better filternig of the possible index needed for optimizations 
        actions = []
        adjacent_movement = possible_move_index
        jump_movement = possible_jump_index
    
        adjacent_movement.each do |index|
            colour = @state[index] == 'B' ? 'B' : 'R'
            case colour
            when 'B'
                actions << "Move(Black)"
            when 'R'
                actions << "Move(Red)"
            end
        end
        jump_movement.each do |index|
            colour = @state[index] == 'B' ? 'B' : 'R'
            case colour
            when 'B'
                actions << "Jump(Black)"
            when 'R'
                actions << "Jump(Red)"
            end
        end

        return actions

    end

  # I decided to put this method here becouse the heuristic is diferent for each game
  def calculate_h
    # Get all black and red cells and calculate the distance from the last cell or the first cell
    h = 0
    @state.each_with_index do |cell, index|
      if cell != 'F'
        h += (cell == 'B') ? @state.length - index : index
      end
    end
    return h
  end
  
end
