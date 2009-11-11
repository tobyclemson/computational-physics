require File.expand_path(File.join(
  File.dirname(__FILE__), '..', 'spec_helper')
)

require 'soliton_project/controller'
require 'matrix'

describe SolitonProject::Controller do

  before(:each) do
    @controller = SolitonProject::Controller.new
  end

  it "should have a default_parameters class attribute accessor" do
    SolitonProject::Controller.should respond_to(:default_parameters)
  end
  
  it "should set the default_parameters attribute" do
    SolitonProject::Controller.default_parameters.should_not be_nil
  end

  it "should have a run method" do
    @controller.should respond_to(:run)
  end
  
  it "should have an input_parameters method" do
    @controller.should respond_to(:input_parameters)
  end
  
  it "should have a generate_initial_condition method" do
    @controller.should respond_to(:generate_initial_condition)
  end
  
  describe "#run" do
    
    before(:each) do
      @initial_condition = mock('initial condition')
      @equation_solver = mock('equation_solver', :data => [0, Vector[1,2,3]])
      @controller.stub!(
        :input_parameters => nil, 
        :generate_initial_condition => @initial_condition,
        :solve_equation => nil,
        :output_results => nil
      )
    end

    it "should call input_parameters, generate_initial_condition, " + 
      "solve_equation and output_results in that order" do
      @controller.should_receive(:input_parameters).ordered
      @controller.should_receive(:generate_initial_condition).ordered
      @controller.should_receive(:solve_equation).ordered
      @controller.should_receive(:output_results).ordered
      @controller.run
    end

  end
  
  describe "#generate_initial_condition" do
    
    it "should raise a NotImplementedError" do
      lambda {
        @controller.generate_initial_condition
      }.should raise_error(NotImplementedError)
    end

  end

end