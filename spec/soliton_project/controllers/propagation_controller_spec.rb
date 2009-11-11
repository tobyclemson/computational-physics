require File.expand_path(File.join(
  File.dirname(__FILE__), '..', '..', 'spec_helper')
)

require 'soliton_project/controllers/propagation_controller'

describe SolitonProject::PropagationController do
  
  before(:each) do
    @propagation_controller = SolitonProject::PropagationController.new
  end
  
  it "should inherit from the SolitonProject::Controller class" do
    @propagation_controller.should be_a_kind_of(SolitonProject::Controller)
  end
  
  it "should redefine the initialize method" do
    @propagation_controller.private_methods(false).should include(
      "initialize"
    )
  end
  
  it "should redefine the generate_initial_condition method" do
    @propagation_controller.public_methods(false).should include(
      "generate_initial_condition"
    )
  end

end