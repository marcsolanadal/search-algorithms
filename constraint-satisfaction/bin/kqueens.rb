class KQueens
  attr_accessor :board, :m

  # Constructor of the class KQueens.
  # This constructor creates a board with one queen in every row and every 
  # column.
  # +m+:: Dimensions of the board.
  def initialize(m)
    @m = m
    @board = Array.new(m){Array.new(m){0}}
    filled_columns = []
    @board.each do |row|
      valid = false
      while ! valid
        empty_column = rand(row.length)
        valid = true unless filled_columns.include?(empty_column)
      end
      filled_columns << empty_column
      row[empty_column] = 1
    end
  end

  # Check if the current board is the solution.
  # Loop all the queens checking if there is any queen have violations. If there 
  # is any violation the method returns false otherwise return true.
  # +return+:: true/false. 
  def check_solution
    violations = 0
    @board.each_with_index do |row, row_index|
      row.each_with_index do |n, column_index|
        violations += check_violations([row_index, column_index]) if @board[row_index][column_index] == 1
      end
    end
    violations == 0 ? true : false
  end

  # Loops all the board randomly until a queen is found.
  # +return+:: Array with the position of the founded queen.
  def choose_queen
    valid = false
    while !valid
      row = rand(@m)
      column = rand(@m)
      valid = true if @board[row][column] == 1
    end
    return [row, column]
  end 

  # Check the violations of a given queen.
  # Given a position of a queen this method loops column, row and all the 
  # diagonals finding another queen. If a queen is found +1 is added to 
  # violations counter.
  # +position+:: Array with the row and column of a given queen.
  # 	0 --> row
  # 	1 --> column
  # +return+:: Number of violations. 
  def check_violations(position)

    violations = 0
    row = position[0]
    column = position[1]
    
    # Vertical column
    for i in 0..@m - 1
      violations += 1 if @board[i][column] == 1 && i != row
    end

    # Horitzontal row 
    for i in 0..@m - 1
      violations += 1 if @board[row][i] == 1 && i != column
    end

    # Second quadrant
    y = row - 1
    x = column - 1
    while x >= 0 && x < column && y >= 0 && y < row
      violations += 1 if @board[y][x] == 1     
      x -= 1
      y -= 1
    end

    # Forth quadrant
    y = row + 1
    x = column + 1
    while x > column && x <= @m - 1 && y > row && y <= @m - 1
      violations += 1 if @board[y][x] == 1      
      x += 1
      y += 1
    end

    # First quadrant
    y = row - 1
    x = column + 1
    while x > column && x <= @m - 1 && y >= 0 && y < row
      violations += 1 if @board[y][x] == 1
      y -= 1
      x += 1
    end

    # Third quadrant
    y = row + 1
    x = column - 1
    while x >= 0 && x < column && y > row && y <= @m - 1
      violations += 1 if @board[y][x] == 1
      y += 1
      x -= 1
    end

    return violations

  end

  # This method overrides the method to string. It prints all the rows of the 
  # matrix. 
  def to_s
    @board.each do |row|
      puts "#{row}"
    end
  end

end
