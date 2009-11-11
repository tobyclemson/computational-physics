require 'soliton_project/controller'
require "soliton_project/equation_solvers/" + 
  "dispersionless_k_de_v_equation_solver"
require "soliton_project/equation_solvers/" + 
  "diffusive_k_de_v_equation_solver"

module SolitonProject
  # The ShockWaveController class overrides the required methods from the 
  # Controller class specific to the shock wave problem.
  class ShockWaveController < Controller

    # Adds values for alpha and spatial_position to the default parameters
    # supplied by the Controller class.
    self.default_parameters = {
      :alpha => 0.7,
      :spatial_position => 0.2
    }

    # Overrides the initialize method to set the default value of the 
    # equation_solver_class instance variable for this class.
    def initialize
      super
      @equation_solver_class = 
        SolitonProject::DispersionlessKDeVEquationSolver
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
    
    # Adds to the default input_parameters method so that the version
    # of the KdeV equation used to solve the shock wave problem can be
    # chosen.
    def input_parameters
      super
      print(
        "\nWhich equation would you like to use to investigate shock " + 
          "waves?\n" +
          "\t1: Dispersionless KdeV equation\n" +
          "\t2: Dispersionless KdeV equation with a diffusion term\n"
      )
      
      none_entered = true
      
      while none_entered
        print("Enter menu item number: ")
        case gets.chomp
          when '1' : 
            @equation_solver_class = 
              SolitonProject::DispersionlessKDeVEquationSolver
            none_entered = false
          when '2' : 
            @equation_solver_class = 
              SolitonProject::DiffusiveKDeVEquationSolver
            none_entered = false
          else
            print("Error: please enter only available menu choices!\n")
            next
        end
      end
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