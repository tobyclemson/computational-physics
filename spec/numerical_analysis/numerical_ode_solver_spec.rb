require File.expand_path(File.join(
  File.dirname(__FILE__), '..', 'spec_helper')
)

require 'numerical_analysis/numerical_ode_solver'

describe NumericalAnalysis::NumericalODESolver do

  describe "#initialize" do
    
    before(:each) do
      @method = :euler
      @initial_condition_vector = mock('initial conditions')
      @function_matrix = mock('function matrix')
      @interval = 0.2
    end
    
    it "should create an instance of the correct NumericalODESolvingMethod " +
      "class passing in the supplied initial_condition_vector, " + 
      "function_matrix and interval" do
      {
        :euler => NumericalAnalysis::EulerMethod, 
        :leapfrog => NumericalAnalysis::LeapfrogMethod, 
        :r_k_4 => NumericalAnalysis::RK4Method
      }.each do |identifier, klass|
        klass.should_receive(
          :new
        ).with(
          @initial_condition_vector, 
          @function_matrix,
          @interval
        )
        
        NumericalAnalysis::NumericalODESolver.new(
          identifier,
          @initial_condition_vector, 
          @function_matrix,
          @interval
        )
      end
    end
    
    it "should raise an ArgumentError error if the supplied method " + 
      "identifer is not recognised" do
      lambda {
        NumericalAnalysis::NumericalODESolver.new(
          :unsupported, 
          @initial_condition_vector, 
          @function_matrix, 
          @interval
        )
      }.should raise_error(ArgumentError)
    end

  end

  describe '#method_missing' do
    
    before(:each) do
      @method = :euler
      @initial_condition_vector = mock('initial conditions')
      @function_matrix = mock('function matrix')
      @interval = 0.2
      @method_object = mock('numerical ode solving method')
      
      NumericalAnalysis::EulerMethod.stub!(:new).and_return(@method_object)
      
      @ode_solver = NumericalAnalysis::NumericalODESolver.new(
        @method, 
        @initial_condition_vector,
        @function_matrix,
        @interval
      )
    end
    
    it "should check whether the method object responds to the called " +
      "method" do
      @method_object.stub!(:method_name)
      @method_object.should_receive(
        :respond_to?
      ).with(
        :method_name
      ).and_return(
        true
      )
      @ode_solver.method_name
    end

    it "should call the called method on the numerical method object if " + 
      "it responds to it" do
      @method_object.stub!(:respond_to?).with(:method_name).and_return(true)
      @method_object.should_receive(:method_name)
      @ode_solver.method_name
    end
    
    it "should raise a NoMethodError error if the numerical method object " +
      "doesn't respond to the called method" do
      @method_object.stub!(:respond_to?).with(:method_name).and_return(false)
      lambda {
        @ode_solver.method_name
      }.should raise_error(NoMethodError)
    end

  end

end