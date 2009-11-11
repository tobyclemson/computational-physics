require File.expand_path(File.join(
  File.dirname(__FILE__), '..', '..', 'spec_helper')
)

require 'soliton_project/controllers/wave_breaking_controller'

describe SolitonProject::WaveBreakingController do
  
  before(:each) do
    @wave_breaking_controller = SolitonProject::WaveBreakingController.new
  end
  
  it "should inherit from the SolitonProject::Controller class" do
    @wave_breaking_controller.should be_a_kind_of(SolitonProject::Controller)
  end
  
  it "should redefine the initialize method" do
    @wave_breaking_controller.private_methods(false).should include(
      "initialize"
    )
  end
  
  it "should redefine the generate_initial_condition method" do
    @wave_breaking_controller.public_methods(false).should include(
      "generate_initial_condition"
    )
  end
  
end