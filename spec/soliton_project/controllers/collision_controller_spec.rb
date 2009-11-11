require File.expand_path(File.join(
  File.dirname(__FILE__), '..', '..', 'spec_helper')
)

require 'soliton_project/controllers/collision_controller'

describe SolitonProject::CollisionController do
  
  before(:each) do
    @collision_controller = SolitonProject::CollisionController.new
  end
  
  it "should inherit from the SolitonProject::Controller class" do
    @collision_controller.should be_a_kind_of(SolitonProject::Controller)
  end
  
  it "should redefine the initialize method" do
    @collision_controller.private_methods(false).should include(
      "initialize"
    )
  end
  
  it "should redefine the generate_initial_condition method" do
    @collision_controller.public_methods(false).should include(
      "generate_initial_condition"
    )
  end

end