require File.expand_path(File.join(
  File.dirname(__FILE__), '..', 'spec_helper')
)

require 'numerical_analysis/numerical_ode_solving_method'
require 'matrix'

describe NumericalAnalysis::NumericalODESolvingMethod do
  
  before(:each) do
    @initial_condition = Vector[0, 0, 0]
    @differential_function = 
      lambda { |independent_variable, dependent_variable|
        Matrix[[1, 0, 0], [0, 1, 0], [0, 0, 1]] * dependent_variable
      }
    @interval = 0.1
    
    @ode_solving_method = NumericalAnalysis::NumericalODESolvingMethod.new(
      @initial_condition, @differential_function, @interval
    )
  end

  describe "public interface" do
    
    it "should have an interval attribute accessor" do
      @ode_solving_method.should respond_to(:interval, :interval=)
    end
    
    it "should have a stability_condition_function attribute writer" do
      @ode_solving_method.should respond_to(:stability_condition_function=)
    end
    
    it "should have a stable? method" do
      @ode_solving_method.should respond_to(:stable?)
    end
    
    it "should have a stability_factor method" do
      @ode_solving_method.should respond_to(:stability_factor)
    end

    it "should have an iterate method" do
      @ode_solving_method.should respond_to(:iterate)
    end
    
    it "should have a current_dependent_variable_value attribute reader" do
      @ode_solving_method.should respond_to(
        :current_dependent_variable_value
      )
    end
    
    it "should have a current_independent_variable_value attribute reader" do
      @ode_solving_method.should respond_to(
        :current_independent_variable_value
      )
    end
    
    it "should have a reset method" do
      @ode_solving_method.should respond_to(
        :reset
      )
    end

  end
  
  describe "#initialize" do
    
    it "should set the current_dependent_variable_value to the supplied" +
      "value" do
      @ode_solving_method.current_dependent_variable_value.should ==
        @initial_condition
    end
    
    it "should set the interval attribute to the supplied value" do
      @ode_solving_method.interval.should == @interval
    end

    it "should allow an initial value for the independent variable to be " +
      "passed in" do
      lambda {
        NumericalAnalysis::NumericalODESolvingMethod.new(
          @initial_condition, 
          @differential_function, 
          @interval, 
          3
        )
      }.should_not raise_error
    end
    
    it "should set the current_independent_variable_value to the supplied" +
      "value" do
      ode_solving_method = NumericalAnalysis::NumericalODESolvingMethod.new(
        @initial_condition, 
        @differential_function, 
        @interval, 
        3.0
      )
      
      ode_solving_method.current_independent_variable_value.should == 3.0
    end

  end

  describe "#reset" do

    it "should set the current_independent_variable_value to zero by " + 
      "default" do
      @ode_solving_method.instance_variable_set(
        :@current_independent_variable_value,
        1.5
      )
      
      @ode_solving_method.reset
      
      @ode_solving_method.current_independent_variable_value.should == 0
    end
    
    it "should set the current_dependent_variable_value to the initial " + 
      "condition passed in at initialisation" do
      @ode_solving_method.instance_variable_set(
        :@current_dependent_variable_value, 
        Vector[1, 1, 1]
      )
      
      @ode_solving_method.reset
      
      @ode_solving_method.current_dependent_variable_value.should ==
        @initial_condition
    end

  end

  describe "#iterate" do

    it "should return an Array instance containing the current independent " +
      "and dependent variable values" do
      @ode_solving_method.iterate.should == [
        0,
        @initial_condition,
      ]
    end

  end
  
  describe "#stable?" do

    it "should call the stability_factor method" do
      @ode_solving_method.should_receive(:stability_factor).and_return(1)
      @ode_solving_method.stable?
    end
    
    it "should return true if the value returned by the stability_factor " +
      "method minus 1 is less than the stability_threshold parameter" do
      @ode_solving_method.stub!(:stability_factor).and_return(1.0001)
      @ode_solving_method.stable?(0.005).should be_true
    end
    
    it "should return false if the value returned by the stability_factor " +
      "method minus 1 is greater than the stability_threshold parameter " do
      @ode_solving_method.stub!(:stability_factor).and_return(1.1)
      @ode_solving_method.stable?(0.05).should be_false
    end
    
    it "should use a stability_threshold value of 0.01 by default" do
      @ode_solving_method.stub!(:stability_factor).and_return(1.1)
      @ode_solving_method.stable?.should be_false
      @ode_solving_method.stable?(0.2).should be_true
    end

  end

  describe "#stability_factor" do

    it "should raise a RuntimeError error if no stability_condition_lambda " +
      "has been set" do
      lambda {
        @ode_solving_method.stability_factor
      }.should raise_error(RuntimeError)
    end
    
    it "should pass the current dependent and independent variables to " +
     "the stability_condition_lambda" do
      @lambda = mock('lambda')
      @ode_solving_method.stability_condition_function = @lambda
      
      @lambda.should_receive(
        :call
      ).with(
        0, @initial_condition
      )
      
      @ode_solving_method.stability_factor
    end
    
    it "should return the result of calling the stability_condition_lambda" do
      @lambda = mock('lambda')
      @lambda.stub!(:call).and_return(1.2)
      
      @ode_solving_method.stability_condition_function = @lambda
      
      @ode_solving_method.stability_factor.should == 1.2
    end

  end

end