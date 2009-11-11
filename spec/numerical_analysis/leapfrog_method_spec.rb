require File.expand_path(File.join(
  File.dirname(__FILE__), '..', 'spec_helper')
)

require 'numerical_analysis/leapfrog_method'
require 'matrix'

describe NumericalAnalysis::LeapfrogMethod do
  
  before(:each) do
    @initial_condition = Vector[0, 0, 0]
    @differential_function = 
      lambda { |independent_variable, dependent_variable|
        Matrix[[1, 0, 0], [0, 1, 0], [0, 0, 1]] * dependent_variable
      }
    @interval = 0.1
    
    @ode_solving_method = NumericalAnalysis::LeapfrogMethod.new(
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
  
  it "should override the reset method" do
    @ode_solving_method.public_methods(false).should include("reset")
  end
  
  it "should override the initialize method" do
    @ode_solving_method.private_methods(false).should include("initialize")
  end
  
  describe "#iterate" do
    
    before(:each) do
      @initial_condition = Vector[1, 2]
      @differential_function = 
        lambda { |independent_variable, dependent_variable|
          Matrix[[1, 2], [3, 4]] * dependent_variable
        }
      
      @ode_solving_method = NumericalAnalysis::LeapfrogMethod.new(
        @initial_condition, @differential_function, @interval
      )
      
      @epsilon = 0.0001
    end

    it "should use the Euler method for the first iteration" do
      first_step = @ode_solving_method.iterate
                 # [0.1, Vector[1.5,3.1]]
      
      first_step[0].should be_close(0.1, @epsilon)
      first_step[1][0].should be_close(1.5, @epsilon)
      first_step[1][1].should be_close(3.1, @epsilon)
    end
    
    it "should use the leapfrog method for the following iterations" do
      # Do Euler step
      @ode_solving_method.iterate
      
      second_step = @ode_solving_method.iterate
                  # [0.2, Vector[2.54,5.38]]
      
      second_step[0].should be_close(0.2, @epsilon)
      second_step[1][0].should be_close(2.54, @epsilon)
      second_step[1][1].should be_close(5.38, @epsilon)
      
      third_step = @ode_solving_method.iterate
                 # [0.3, Vector[4.16,8.928]]
      
      third_step[0].should be_close(0.3, @epsilon)
      third_step[1][0].should be_close(4.16, @epsilon)
      third_step[1][1].should be_close(8.928, @epsilon)
    end

  end

end