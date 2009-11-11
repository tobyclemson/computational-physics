require File.expand_path(File.join(
  File.dirname(__FILE__), '..', 'spec_helper')
)

require 'numerical_analysis/rk4_method'
require 'matrix'

describe NumericalAnalysis::RK4Method do

  before(:each) do
    @initial_condition = Vector[0, 0, 0]
    @differential_function = 
      lambda { |independent_variable, dependent_variable|
        Matrix[[1, 0, 0], [0, 1, 0], [0, 0, 1]] * dependent_variable
      }
    @interval = 0.1
    
    @ode_solving_method = NumericalAnalysis::RK4Method.new(
      @initial_condition, @differential_function, @interval
    )
  end

  it "should inherit from the NumericalODESolvingMethod class" do
    @ode_solving_method.should be_a_kind_of(
      NumericalAnalysis::NumericalODESolvingMethod
    )
  end
  
  it "should override the iterate method" do
    @ode_solving_method.public_methods(false).should include("iterate")
  end
  
  describe "#iterate" do

    before(:each) do
      @initial_condition = Vector[1, 2]
      @differential_function = 
        lambda { |independent_variable, dependent_variable|
          Matrix[[1, 2], [3, 4]] * dependent_variable
        }
      
      @ode_solving_method = NumericalAnalysis::RK4Method.new(
        @initial_condition, @differential_function, @interval
      )
    end

    it "should return a value that is the result of applying the RK4 " + 
      "method to the current variable values" do
      epsilon = 0.00000001
        
      next_vector = @ode_solving_method.iterate
                  # [0.1, Vector[1.6624125,3.4549291667]]

      next_vector[0].should be_close(0.1, epsilon)
      next_vector[1][0].should be_close(1.6624125, epsilon)
      next_vector[1][1].should be_close(3.4549291667, epsilon)
    end

  end

end