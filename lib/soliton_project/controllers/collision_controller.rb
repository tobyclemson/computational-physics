require 'soliton_project/controller'
require 'soliton_project/equation_solvers/k_de_v_equation_solver'

module SolitonProject
  # The ShockWaveController class overrides the required methods from the 
  # Controller class specific to the shock wave problem.
  class CollisionController < Controller
    
    # Adds to and overrides values of the default parameters supplied by 
    # the Controller class.
    self.default_parameters = {
      :alpha1 => 1.5,
      :alpha2 => 0.6,
      :number_of_spatial_points => 400,
      :number_of_temporal_points => 2000,
      :spatial_offset1 => 0.1,
      :spatial_offset2 => 0.3
    }
    
    # Overrides the initialize method to set the default value of the 
    # equation_solver_class instance variable for this class.
    def initialize
      super
      @equation_solver_class = SolitonProject::KDeVEquationSolver
    end
    
    # Generates an initial condition consisting of two independent solitons
    # separated from each other along the spatial extent.
    def generate_initial_condition
      initial_condition_elements = []
      (0...@parameters[:number_of_spatial_points]).each do |n|
        first_soliton_point = soliton_point(
          n, @parameters[:alpha1], @parameters[:spatial_offset1]
        )
        second_soliton_point = soliton_point(
          n, @parameters[:alpha2], @parameters[:spatial_offset2]
        )
        initial_condition_elements << (
          first_soliton_point + second_soliton_point
        )
      end
      @initial_condition = Vector.elements(initial_condition_elements)
    end
    
    private
    
      # Calculates the correct value of the analytical soliton function
      # based on the supplied _n_, _alpha_ and _spatial_offset_.
      def soliton_point(n, alpha, spatial_offset)
        return u(@parameters[:x_interval] * (n - (
              @parameters[:number_of_spatial_points] * 
              spatial_offset
            )
          ), 0, alpha
        )
      end
  
      # Calculates the value of the sech function at _x_.
      def sech(x)
        return 2.0/(Math.exp(x) + Math.exp(-x))
      end
      
      # Calculates the value of the analytical soliton solution at _x_ and
      # _t_ using the value of alpha stored in the parameters hash.
      def u(x, t, alpha)
        return 12 * alpha ** 2 * (
          sech(
            alpha * (x - 4 * alpha ** 2 * t)
          )
        ) ** 2
      end
    
  end
end