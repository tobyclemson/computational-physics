require File.expand_path(File.join(
  File.dirname(__FILE__), '..', '..', 'spec_helper')
)

require 'soliton_project/equation_solvers/diffusive_k_de_v_equation_solver'

describe SolitonProject::DiffusiveKDeVEquationSolver do
  
  before(:each) do
    @initial_condition = Vector[1, 0.5, 0, 0, 0, 0, 0, 0, 0, 0]
    @number_of_iterations = 100
    @x_interval = 1
    @t_interval = 0.01
    @diffusive_k_de_v_equation_solver = 
      SolitonProject::DiffusiveKDeVEquationSolver.new(
        @initial_condition,
        @number_of_iterations,
        @x_interval,
        @t_interval
      )
  end

  it "should inherit from the EquationSolver class" do
    @diffusive_k_de_v_equation_solver.should be_a_kind_of(
      SolitonProject::EquationSolver
    )
  end
  
  it "should overwrite the differential_function method" do
    @diffusive_k_de_v_equation_solver.public_methods(false).should 
      include(
        "differential_function"
      )
  end
  
  describe "#differential_function" do

    it "should return an object that responds to call" do
      @diffusive_k_de_v_equation_solver.differential_function.should 
        respond_to(:call)
    end

  end

end