require 'soliton_project/controller'
require 'soliton_project/equation_solvers/k_de_v_equation_solver'

module SolitonProject
  # The WaveBreakingController class overrides the required methods from the 
  # Controller class specific to the wave braking problem.
  class WaveBreakingController < Controller
    
    # Adds to and overrides values of the default parameters supplied by 
    # the Controller class.
    self.default_parameters = {
      :amplitude => 1.0,
      :period => 20.0,
      :spatial_offset => 0.1,
      :number_of_spatial_points => 600
    }

    # Overrides the initialize method to set the default value of the 
    # equation_solver_class instance variable for this class.
    def initialize
      super
      @equation_solver_class = SolitonProject::KDeVEquationSolver
    end

    # Generates a positive half period sine wave as the initial condition
    # using the supplied amplitude, period and spatial_offset parameters.
    def generate_initial_condition
      initial_condition_elements = []
      
      num_wave_points = (
        (@parameters[:period]/2) / @parameters[:x_interval]
      ).to_i
      
      num_zero_points_before = 
        (
          @parameters[:spatial_offset] * 
          @parameters[:number_of_spatial_points]
        ).to_i
        
      num_zero_points_after = 
        @parameters[:number_of_spatial_points] - 
        num_wave_points - 
        num_zero_points_before
        
      (0..num_zero_points_before).each do |n|
        initial_condition_elements << 0.0
      end
      
      (0...num_wave_points).each do |n|
        initial_condition_elements << sine_wave_point(
          n * @parameters[:x_interval]
        )
      end
      
      (0..num_zero_points_after).each do |n|
        initial_condition_elements << 0.0
      end
      
      @initial_condition = Vector.elements(initial_condition_elements)
    end

    private

      # Returns the value of the sine wave at the value of _x_ such that
      # the maximum value of x maps to theta = pi.
      def sine_wave_point(x)
        return @parameters[:amplitude] * Math.sin(
          (2 * Math::PI / @parameters[:period]) * x
        )
      end
          
  end
end