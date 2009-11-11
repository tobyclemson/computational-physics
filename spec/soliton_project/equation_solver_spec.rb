require File.expand_path(File.join(
  File.dirname(__FILE__), '..', 'spec_helper')
)

require 'soliton_project/equation_solver'
require 'matrix'

describe SolitonProject::EquationSolver do
  
  before(:each) do
    @initial_condition = Vector[1, 0.5, 0, 0, 0, 0, 0, 0, 0, 0]
    @number_of_iterations = 100
    @x_interval = 1
    @t_interval = 0.01
    @equation_solver = SolitonProject::EquationSolver.new(
      @initial_condition,
      @number_of_iterations,
      @x_interval,
      @t_interval
    )
    
    @equation_solver.stub!(:print)
  end

  it "should have a setup method" do
    @equation_solver.should respond_to(:setup)
  end
  
  it "should have a differential_function method" do
    @equation_solver.should respond_to(:differential_function)
  end
  
  it "should have a solve method" do
    @equation_solver.should respond_to(:solve)
  end
  
  describe "#setup" do
    
    before(:each) do
      @differential_function = mock('differential function')
      @equation_solver.stub!(
        :differential_function
      ).and_return(
        @differential_function
      )
    end

    it "should call the differential_function method" do
      @equation_solver.should_receive(:differential_function)
      @equation_solver.setup
    end
    
    it "should create an instance of the NumericalODESolver class passing " + 
      "in the values provided at initialisation and the " + 
      "differential_function" do
      NumericalAnalysis::NumericalODESolver.should_receive(
        :new
      ).with(
        anything,
        @initial_condition,
        @differential_function,
        @t_interval
      )
      @equation_solver.setup
    end
    
    it "should allow the method to use to be specified" do
      NumericalAnalysis::NumericalODESolver.should_receive(
        :new
      ).with(
        :method,
        anything,
        anything,
        anything
      )
      @equation_solver.setup(:method)
    end

  end

  describe "#differential_function" do

    it "should raise a NotImplementedError" do
      lambda {
        @equation_solver.differential_function
      }.should raise_error(NotImplementedError)
    end

  end

  describe "#solve" do

    before(:each) do
      @numerical_ode_solver = mock('numerical_ode_solver')
      
      @equation_solver.stub!(:differential_function)
      @numerical_ode_solver.stub!(
        :iterate
      ).and_return(
        [0, @initial_condition]
      )
      NumericalAnalysis::NumericalODESolver.stub!(
        :new
      ).and_return(
        @numerical_ode_solver
      )
      
      @equation_solver.setup
    end
    
    it "should add number_of_iterations rows to the data attribute" do
      @equation_solver.solve
      @equation_solver.should have(@number_of_iterations + 1).data
    end

  end

end