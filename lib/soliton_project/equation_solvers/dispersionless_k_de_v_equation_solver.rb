require 'sparse_matrix'
require 'soliton_project/equation_solver'

module SolitonProject
  # Represents the discretised Korteweg de Vries equation with the 
  # dispersion term removed and allows it to be solved numerically. An 
  # arbitrary initial condition is supplied and a solution is generated over 
  # a specified number of steps and stored as an array of points in the 
  # solution.
  class DispersionlessKDeVEquationSolver < EquationSolver
    
    # Generates a lambda representing the discretised Korteweg de Vries 
    # equation.
    def differential_function
      # Calculate a value for q (see report) using the supplied 
      # interval.
      q = 1.0/(4.0 * @x_interval)
    
      # Create the matrix required for the differential function.
    
      # Calculate the size of the required matrices.
      matrix_size = @initial_condition.size
    
      # Generate the correct elements to construct the required matrix.
      b_elements = []
    
      (0...matrix_size).each do |row_index|
        i_minus_2 = (matrix_size + (row_index - 2)) % matrix_size
        i_minus_1 = (matrix_size + (row_index - 1)) % matrix_size
        i_plus_1  = (matrix_size + (row_index + 1)) % matrix_size 
        i_plus_2  = (matrix_size + (row_index + 2)) % matrix_size
      
        b_elements << [row_index, i_minus_1, q]
        b_elements << [row_index, i_plus_1, (-1 * q)]
      end
    
      # Create the matrix B (see report) required for the 
      # differential_function parameter passed to the numerical ODE solver.
      b = SparseMatrix[*b_elements]
    
      # Create the differential function and return it.
      return lambda { |independent_variable, dependent_variable|
        b * dependent_variable.collect { |e| 
          e ** 2
        }
      }
    end
    
  end
end