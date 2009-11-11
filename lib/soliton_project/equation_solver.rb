require 'numerical_analysis'

module SolitonProject
  # The EquationSolver class is an abstract class from which each of the
  # concrete equation solving classes should inherit. It provides the 
  # basic functionality required to provide a solution to a discretised 
  # equation of two variables.
  class EquationSolver
    # An array of the data points in the solution to the equation represented
    # by this EquationSolver class.
    attr_reader :data
    
    # Initialises an instance of the EquationSolver class.
    # 
    # Instances are created by passing in 4 parameters:
    # _initial_condition_::         A vector of the initial spatial points
    #                               to be propagated using the equation.
    # _number_of_iterations_::      The number of iterations of the equation 
    #                               to perform.
    # _x_interval_::                The interval between points in space.
    # _t_interval_::                The interval between points in time.
    def initialize(
      initial_condition, 
      number_of_iterations, 
      x_interval, 
      t_interval
    )
      @data = [[0, initial_condition]]
      @initial_condition = initial_condition
      @number_of_iterations = number_of_iterations
      @x_interval = x_interval
      @t_interval = t_interval
    end
    
    # Creates the required NumericalODESolver using the values supplied
    # at object initialisation. 
    # 
    # The differential_function method is called to generate the 
    # differential function to be passed to the NumericalODESolver 
    # constructor. Derivatives of this class should define this method to 
    # return a lambda representing the particular equation they represent.
    # 
    # The optional _method_ attribute specifies the numerical method to use
    # to solve the equation. By default, the RK4 method is used.
    def setup(method = :r_k_4_method)
      @numerical_ode_solver = NumericalAnalysis::NumericalODESolver.new(
        method, @initial_condition, differential_function, @t_interval
      )
      return true
    end
    
    # Returns a lambda representing the differential function corresponding
    # to this equation.
    # 
    # In this abstract class, the method just raises a NotImplementedError.
    def differential_function
      raise NotImplementedError
    end
    
    # Solves the equation represented by this class by creating as many 
    # data points in the data set as the requested number of iterations.
    def solve
      @number_of_iterations.times do |n|
        print('|') if n % (@number_of_iterations/100) == 0
        STDOUT.flush
        @data << @numerical_ode_solver.iterate
      end
    end
    
  end
end