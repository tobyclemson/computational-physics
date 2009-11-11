require 'soliton_project/controller'
require 'soliton_project/equation_solvers/k_de_v_equation_solver'

module SolitonProject
  # The PropagationController class overrides the required methods from the 
  # Controller class specific to the problem of propagating soliton waves.
  class PropagationController < Controller
    
    # Adds values for alpha and spatial_position to the default parameters
    # supplied by the Controller class.
    self.default_parameters = {
      :alpha => 1.5,
      :spatial_position => 0.3
    }
    
    # Overrides the initialize method to set the default value of the 
    # equation_solver_class instance variable for this class.
    def initialize
      super
      @equation_solver_class = SolitonProject::KDeVEquationSolver
    end
    
    # Generates a soliton wave as the initial condition.
    def generate_initial_condition
      initial_condition_elements = []
      (0...@parameters[:number_of_spatial_points]).each do |n|
        initial_condition_elements << u(
          @parameters[:x_interval] * (
            n - (
              @parameters[:number_of_spatial_points] * 
              @parameters[:spatial_position]
            )
          ),
          0
        )
      end
      @initial_condition = Vector.elements(initial_condition_elements)
    end
    
    private
    
      # Calculates the value of the sech function at _x_.
      def sech(x)
        return 2.0/(Math.exp(x) + Math.exp(-x))
      end
      
      # Calculates the value of the analytical soliton solution at _x_ and
      # _t_ using the value of alpha stored in the parameters hash.
      def u(x, t)
        return 12 * @parameters[:alpha] ** 2 * (
          sech(
            @parameters[:alpha] * (x - 4 * @parameters[:alpha] ** 2 * t)
          )
        ) ** 2
      end
    
  end
end